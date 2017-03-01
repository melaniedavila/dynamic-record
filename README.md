# DynamicRecord

DynamicRecord is a lightweight Ruby object relational mapping (ORM) library inspired by Ruby on Rails' ActiveRecord. It was built using meta-programming techniques as well as the ActiveSupport::Inflector library. The ORM allows you to seamlessly perform database operations without writing SQL code.

DynamicRecord establishes and relies upon naming conventions to create associations between database tables.

## Features and Implementation
The ORM provides users with various methods to facilitate database interaction, including:
- `::all`
- `::find`
- `::where`
- `#save` (intelligently determines whether to insert a new entry or update an existing one)

When inserting a new record into the database, DynamicRecord ensures that the record's id is not manually generated.

``` ruby
def insert
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
```

In addition, it supports the following associations:
- `belongs_to`
- `has_many`
- `has_one_through`

The has_one_through association was carefully crafted to ensure that both source and through classes are defined at the time of method invocation.

``` ruby
def has_one_through(name, through_name, source_name)
  define_method(name) do
    # Note: through_options and source_options variables are declared
    # within the method definition
    through_options = self.class.assoc_options[through_name]
    source_options = through_options.model_class.assoc_options[source_name]

    query_results = self.class.has_one_through_query(self, through_options, source_options)
    source_options.model_class.parse_all(query_results).first
  end
end
```