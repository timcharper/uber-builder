module UberBuilder
  module TemplatedMethods
    def file_column_field(field, options = {})
      field = field.to_s
      tabular_options = extract_tabular_options(field, options)
      generic_field(field, @template.file_column_field(@object_name.to_s, field, options), tabular_options)
    end
  end
  
  class StaticBuilder
    
  end
end
