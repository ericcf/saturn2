module ControllerHelpers

  # Returns comma-separated errors on the model.
  def errors_on(record)
    record.errors.full_messages.join ", "
  end

  # Returns either the parsed date or nil.
  def parse_date(string)
    begin
      Date.parse(string)
    rescue ArgumentError
      nil
    end
  end
end
