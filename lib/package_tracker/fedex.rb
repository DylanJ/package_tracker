module PackageTracker
  module Tracker
    module FedEx
      URL = "https://www.fedex.com/trackingCal/track"

      def self.lookup id
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
          data: '{"TrackPackagesRequest":{"appType":"wtrk","uniqueKey":"","processingParameters":{"anonymousTransaction":true,"clientId":"WTRK","returnDetailedErrors":true,"returnLocalizedDateTime":false},"trackingInfoList":[{"trackNumberInfo":{"trackingNumber":"' + id + '","trackingQualifier":"","trackingCarrier":""}}]}}',
          action: 'trackpackages',
          locale: 'en_US',
          format: 'json',
          version: '99'
        })

        response = JSON.parse(http.request(req).body)

        info = response["TrackPackagesResponse"]["packageList"][0]

        if (errors = info['errorList']).present?
          return { response: 'failure', message: errors.first['message'] }
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
    end
  end
end

