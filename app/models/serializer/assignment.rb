module Serializer

  module Assignment

    def full_id
      "#{self.class.to_s}#{id}"
    end

    def serializable_hash(options = {})
      json_options = {
        only: [:date, :physician_id, :public_note, :shift_id],
        methods: [:full_id, :start_time, :end_time, :adjusted_duration, :physician_type, :label_text]
      }
      if options[:role].blank? || options[:role] == "admin"
        json_options[:only].concat([:private_note, :updated_at])
        json_options[:methods].concat([:editor_display_name])
      end
      super(json_options.merge(options))
    end
  end
end
