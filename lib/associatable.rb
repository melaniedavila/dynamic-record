require_relative 'sql_object'

module Associatable
  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)
    define_method(name) do
      options = self.class.assoc_options[name]
      primary_key = options.primary_key
      foreign_key_val = self.send(options.foreign_key)
      target_model_class = options.model_class
      target_model_class.where(primary_key => foreign_key_val).first
    end
  end

  def has_many(name, options = {})
    self_class_name = self.name
    self.assoc_options[name] = HasManyOptions.new(name, self_class_name, options)
    define_method(name) do
      options = self.class.assoc_options[name]
      foreign_key = options.foreign_key
      primary_key_val = self.send(options.primary_key)
      target_model_class = options.model_class
      target_model_class.where(foreign_key => primary_key_val)
    end
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      query_results = self.class.has_one_through_query(self, through_options, source_options)
      source_options.model_class.parse_all(query_results).first
    end
  end

  def has_one_through_query(instance, through_options, source_options)
    through_class = through_options.model_class
    through_primary_key = through_options.primary_key
    through_foreign_key = through_options.foreign_key
    through_table = through_options.table_name

    source_primary_key = source_options.primary_key
    source_foreign_key = source_options.foreign_key
    source_table = source_options.table_name

    through_foreign_key_value = instance.send(through_foreign_key)

    DBConnection.execute(<<-SQL, through_foreign_key_value)
      SELECT
        #{source_table}.*
      FROM
        #{source_table}
      JOIN
        #{through_table}
      ON
        #{source_table}.#{source_primary_key} = #{through_table}.#{source_foreign_key}
      WHERE
        #{through_table}.#{through_primary_key} = ?
    SQL
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
