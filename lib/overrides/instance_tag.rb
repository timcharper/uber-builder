class ActionView::Helpers::InstanceTag

  def wrap_with_errors_if_needed(output)
    if object.respond_to?("errors") && object.errors.respond_to?("on")
      error_wrapping(output, object.errors.on(@method_name))
    else
      output
    end
  end
end
  