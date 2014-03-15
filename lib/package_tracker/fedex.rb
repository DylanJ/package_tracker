module PackageTracker
  module Tracker
    module FedEx
      IDLength = 34
      URL = "https://www.fedex.com/trackingCal/track"

      def self.lookup id
        response = request(id)

        info = response["TrackPackagesResponse"]["packageList"][0]

        if (error = info['errorList'].first['message']).present?
          return { response: 'failure', message: error }
        end

        status = info["statusWithDetails"]
        carrier = info["trackingCarrierDesc"]
        events = info["scanEventList"].map do |event|
          {
            date: "#{event['date']} #{event['time']}",
            location: event['scanLocation'],
            status: event['status']
          }
        end

        {
          response: 'success',
          carrier: carrier,
          status: status,
          events: events
        }
      end

      def self.request id
        uri = URI.parse(URL)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        req = Net::HTTP::Post.new(uri.request_uri, {
          'Referer' => "https://www.fedex.com/fedextrack/?tracknumbers=#{id}&locale=en",
          'User-Agent'=> "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)",
          'X-Requested-With' => 'XMLHttpRequest',
          'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8'
        })

        req.set_form_data( {
          data: request_payload(id),
          action: 'trackpackages',
          locale: 'en_US',
          format: 'json',
          version: '99'
        })

        JSON.parse(http.request(req).body)
      end

      def self.request_payload id
        {
          TrackPackagesRequest: {
            appType: "wtrk",
            uniqueKey: "",
            processingParameters: {
              anonymousTransaction: true,
              clientId: 'WTRK',
              returnDetailedErrors: true,
              returnLocalizedDateTime: false,
            },
            trackingInfoList: [
              {
                trackNumberInfo: {
                  trackingNumber: id,
                  trackingQualifier: "",
                  trackingCarrier: ""
                }
              }
            ]
          }
        }.to_json
      end
    end
  end
end

