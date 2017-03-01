require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)
    where_details = params.keys.map { |key| "#{key} = ?"}.join(" AND ")
    param_values = params.values
    DBConnection.execute(<<-SQL, param_values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_details}
    SQL
      .map { |datum| self.new(datum) }
  end
end

class SQLObject
  extend Searchable
end
