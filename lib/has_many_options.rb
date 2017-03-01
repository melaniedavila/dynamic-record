require_relative 'assoc_options'
require 'active_support/inflector'

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      foreign_key: :"#{self_class_name.underscore}_id",
      class_name: "#{name.to_s.singularize.camelcase}",
      primary_key: :id
    }

    self.foreign_key = options[:foreign_key] || defaults[:foreign_key]
    self.class_name = options[:class_name] || defaults[:class_name]
    self.primary_key = options[:primary_key] || defaults[:primary_key]
  end
end
