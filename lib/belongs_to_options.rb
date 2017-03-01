require_relative 'assoc_options'

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      foreign_key: :"#{name}_id",
      class_name: "#{name.capitalize}",
      primary_key: :id
    }

    self.foreign_key = options[:foreign_key] || defaults[:foreign_key]
    self.class_name = options[:class_name] || defaults[:class_name]
    self.primary_key = options[:primary_key] || defaults[:primary_key]
  end
end
