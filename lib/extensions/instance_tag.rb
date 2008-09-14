class ActionView::Helpers::InstanceTag

  def wrap_with_errors_if_needed(output)
    if object.respond_to?("errors") && object.errors.respond_to?("on")
      error_wrapping(output, object.errors.on(@method_name))
    else
      output
    end
  end
  
  def column_info
    @column_info ||= object.class.respond_to?(:columns_hash) && object.class.columns_hash[@method_name.to_s]
  end
  
  def column_type
    self.column_info && self.column_info.type
  end
  
  def column_scale
    @column_scale ||= self.column_info && self.column_info.scale
  end
end
  