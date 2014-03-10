require "package_tracker/engine"
require 'active_shipping'
include ActiveMerchant::Shipping

module PackageTracker
  class Tracker
    def initialize
      fedex_credentials = Rails.application.config.tracker['fedex']

      @fedex ||= FedEx.new(
        login: fedex_credentials['login'],
        password: fedex_credentials['password'],
        key: fedex_credentials['key'],
        account: fedex_credentials['account'],
        test: !Rails.env.prod?
      )
    end

    # takes a DHL or FedEx tracking ID and returns a hash of the
    # tracking information.
    def track id
      raise "No tracking ID specified" if id.blank?

      if method = shipping_method(id)
        return send(method, id)
      end

      { error: 'Invalid tracking ID' }
    end

    private

    # determines the shipping method of the id
    def shipping_method id
      return :fedex
    end

    def fedex id, carrier='fedex_ground'
      # there's also the carrier fedex_express
      data = @fedex.find_tracking_info( id, carrier_code: carrier )

      {
        status: data.status,
        shipment_time: data.shipment_time,
        destination: data.destination,
        events: data.shipment_events
      }
    end
  end
end
