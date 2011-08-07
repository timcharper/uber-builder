module NumberFieldHelpers
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers
protected  
  def extract_number_field_options(options, column_type = nil, column_scale = nil)
    number_options = {
      :precision => options.delete("precision"),
      :unit => options.delete("unit") || "$",
      :separator => options.delete("separator") || ".",
      :delimiter => options.delete("delimiter") || ","
    }
    
    # auto-detect type
    number_options[:precision] ||= 0 if column_type == :integer
    number_options[:precision] ||= column_scale if column_scale
    number_options.delete_if { |k,v| v.nil? }
  end
  
  def apply_precision(str_value, number_options = {})
    return str_value if number_options[:precision].nil? || str_value.blank?
    "%0.#{number_options[:precision]}f" % str_value.to_f
  end
  
  def apply_precision_and_delimiter(str_value, number_options)
    return "" if str_value.blank?
    parts = apply_precision(str_value, number_options).split(".")
    
    parts[0] = number_with_delimiter(parts[0], :delimiter => number_options[:delimiter])
    parts * number_options[:separator]
  end
end
