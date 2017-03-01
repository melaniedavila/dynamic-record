require_relative 'lib/sql_object'

COOKBOOKS_DB_FILE = 'cookbooks.db'
COOKBOOKS_SQL_FILE = 'cookbooks.sql' # gives you option to reset db

`rm '#{COOKBOOKS_DB_FILE}'`
`cat '#{COOKBOOKS_SQL_FILE}' | sqlite3 '#{COOKBOOKS_DB_FILE}'`

class Cookbook < SQLObject
  has_many :recipes
  finalize!
end

class Recipe < SQLObject
  has_many :ingredients
  belongs_to :cookbook
  finalize!
end

class Ingredient < SQLObject
  belongs_to :recipe
  has_one_through :cookbook, :recipe, :cookbook
  finalize!
end
