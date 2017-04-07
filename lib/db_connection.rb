require 'sqlite3'
require 'yaml'

PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'false' ? false : true
ROOT_FOLDER = File.join(File.dirname(__FILE__), '..')

class DBConnection
  def self.open(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def self.reset
    sql_file_absolute_path = File.join(ROOT_FOLDER, sql_file_basename)
    db_file_absolute_path = sql_file_absolute_path.sub(/sql$/, 'db')

    # We don't need to know if `rm` fails, so we can send any of its
    # error output to `/dev/null`.
    commands = [
      "rm '#{db_file_absolute_path}' 2&>/dev/null",
      "cat '#{sql_file_absolute_path}' | sqlite3 '#{db_file_absolute_path}'"
    ]

    commands.each { |command| `#{command}` }
    DBConnection.open(db_file_absolute_path)
  end

  def self.instance
    reset if @db.nil?

    @db
  end

  def self.execute(*args)
    print_query(*args)
    # executes the given SQL statement
    instance.execute(*args)
  end

  def self.execute2(*args)
    print_query(*args)
    # similar to execute, exexute2 executes the given SQL statement; however,
    # the first row returned is always the names of the columns
    instance.execute2(*args)
  end

  # obtains the unique row id of the next row to be inserted in the database
  def self.last_insert_row_id
    instance.last_insert_row_id
  end

  def self.sql_file_basename
    @sql_file_basename ||= begin
      database_yml = YAML.load_file('config/database.yml')
      database_yml['sql_file_basename']
    end
  end

  # Below allows the user to set the sql_file_basename without needing to
  # modify the config file. When getter method is called, @sql_file_basename
  # will be defined and we will not have to read the config file
  def self.sql_file_basename=(sql_file_basename)
    @sql_file_basename = sql_file_basename
  end

  private

  def self.print_query(query, *interpolation_args)
    return unless PRINT_QUERIES

    puts '--------------------'
    puts query
    unless interpolation_args.empty?
      puts "interpolate: #{interpolation_args.inspect}"
    end
    puts '--------------------'
  end
end
