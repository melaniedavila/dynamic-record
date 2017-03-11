require_relative 'lib/sql_object'
require 'pry'

# Note that we don't need to set `sql_file_basename` on DBConnection.
# Instead, we can just get the default value from `config/database.yml`

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
  has_one_through :cookbook, :recipe
  finalize!
end

puts <<-EOF
Not sure where to start? Try these queries:

- Cookbook.all
- Cookbook.all.first.recipes
- Recipe.all
- Recipe.all.last.ingredients
- Recipe.all.last.cookbook
- Recipe.find(2)
- Ingredient.all.first.recipe
- Ingredient.all.first.cookbook
- Ingredient.where(recipe_id: 3)
EOF

binding.pry(quiet: true)
