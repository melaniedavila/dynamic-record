require 'active_support/inflector'

class AssocOptions
  attr_accessor :foreign_key, :class_name, :primary_key

  # uses ActiveSupport's inflector library in order to return a class object
  def model_class
    self.class_name.constantize
  end

  def table_name
    class_name = self.class_name
    class_name == "Human" ? "humans" : class_name.downcase.pluralize
  end
end
