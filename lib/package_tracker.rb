require "package_tracker/engine"
require "nokogiri"
require "open-uri"
require "package_tracker/fedex"
require "package_tracker/dhl"

module PackageTracker
  module Tracker
    include FedEx
    include DHL

    # takes a DHL or FedEx tracking ID and returns a hash of the
    # tracking information.
    def self.lookup id
      raise "No tracking ID specified" if id.blank?

      if method = shipping_method(id)
        return method.lookup(id)
      end

      { response: 'failure', message: 'Invalid tracking ID' }
    end

    def self.contains_alpha_characters? string
      !!/[^0-9]/.match(string)
    end

    # determines the shipping method of the id
    def self.shipping_method id
      return nil if contains_alpha_characters?(id)

      case id.length
      when 12
        return DHL
      when 34
        return FedEx
      end
    end
  end
end
