module Serializer

  module GuestMembership

    def serializable_hash(options = {})
      super({
        only: [:id, :family_name, :given_name],
        methods: [:type]
      }.merge(options))
    end
  end
end
