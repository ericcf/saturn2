module Saturn

  module HasHumanName

    def short_name
      "#{given_name[0]} #{family_name}"
    end

    def full_name(*args)
      if args.delete(:family_first)
        "#{family_name}, #{given_name}"
      else
        "#{given_name} #{family_name}"
      end
    end
  end
end
