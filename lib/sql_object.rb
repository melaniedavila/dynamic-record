require_relative 'associatable'
require_relative 'db_connection'
require_relative 'searchable'
require 'active_support/inflector'

class SQLObject
  extend Searchable
  extend Associatable

  # queries the database once in order to return an array of all column
  # names as symbols
  def self.columns
    # DBConnection#execute2 returns an array, where the first element
    # is a subarray of column names
    @columns ||= DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      LIMIT
       0 -- ensures we do not retrieve any database records, only column names
    SQL
      .first.map(&:to_sym)
  end

  # will be called at the end of a SQLObject sublass definition in order
  # to add getter and setter methods
  def self.finalize!
    self.columns.each do |col|
      # define_method defines an instance method in the receiver
      define_method(col) { self.attributes[col] }

      define_method("#{col}=") { |val| self.attributes[col] = val }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    # uses ActiveSupport's inflector library to convert the class name to
    # snake case and provide pluralization
    @table_name || self.name.underscore.pluralize
  end

  def self.all
    query_results = DBConnection.execute(<<-SQL)
      SELECT
        "#{self.table_name}".*
      FROM
        #{self.table_name}
      SQL

      self.parse_all(query_results)
  end

  def self.parse_all(results)
    # returns an array of objects of the same class as self
    results.map { |res| self.new(res) }
  end

  # returns a single object
  def self.find(id)
    query_results = DBConnection.execute(<<-SQL, id)
    SELECT
      "#{self.table_name}".*
    FROM
      #{self.table_name}
    WHERE
      id = ?
    LIMIT
      1
    SQL

    self.parse_all(query_results).first
  end

  def initialize(params = {})
    # Sets each attribute on the object
    params.each do |attr_name, attr_val|
      if self.class.columns.include?(attr_name.to_sym)
        self.send("#{attr_name}=", attr_val)
      else
        raise "Unknown attribute '#{attr_name}'"
      end
    end
  end

  # returns a hash of our model's columns and values
  def attributes
    @attributes ||= {}
  end

  # returns an array of values for each attribute
  def attribute_values
    self.class.columns.map { |col| self.send(col) }
  end

  def save
    id.nil? ? insert : update
  end

  private

    def insert
      # dropping the first element of the columns array ensures that we
      # do not insert a custom id into the database
      cols = self.class.columns.drop(1).map(&:to_s)
      col_names = cols.join(", ")
      question_marks = (["?"] * (cols.count)).join(", ")
      DBConnection.execute(<<-SQL, *attribute_values.drop(1))
        INSERT INTO
          #{self.class.table_name} (#{col_names})
        VALUES
          (#{question_marks})
      SQL

      self.id = DBConnection.last_insert_row_id
    end

    def update
      set_details = self.class.columns.
          map { |attr_name| "#{attr_name} = ?"}.
          join(", ")

      DBConnection.execute(<<-SQL, *attribute_values, self.id)
        UPDATE
          #{self.class.table_name}
        SET
          #{set_details}
        WHERE
          id = ?
      SQL
    end
  end
