module Serializer

  module GuestAssignment

    def full_id
      "#{self.class.to_s}#{id}"
    end

    def serializable_hash(options = {})
      json_options = {
        only: [:date, :shift_id],
        methods: [:full_id, :physician_id, :start_time, :end_time, :physician_type]
      }
      if options[:role].blank? || options[:role] == "admin"
        json_options[:only].push(:updated_at)
        json_options[:methods].push(:editor_display_name)
      end
      json = super(json_options.merge(options))
      json["id"] = "guest_assignment_#{id}"

      json
    end
  end
end
