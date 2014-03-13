require "package_tracker/engine"
require "nokogiri"
require "open-uri"

module PackageTracker
  class Tracker
    def initialize
    end

    def dhl id
      status_row = 2          # third row in tbody
      status_text_cell = 2    # third cell in <td>
      status_text_element = 2 # "text<br>status"

      url = "http://nolp.dhl.de/nextt-online-public/set_identcodes.do?lang=#{I18n.locale.to_s}&idc=#{id}&extendedSearch=true"
      doc = Nokogiri::HTML(open(url))

      dhl_table = doc.css('table')
      status = clean(dhl_table.css('tbody tr')[status_row].css('td')[status_text_cell].children[status_text_element].content)

      updates_table = doc.css('table table')

      headers = [:date, :location, :status]

      updates = updates_table.css('tbody tr').map do |row|
        result = {}
        cols = row.css('td').map { |cell| clean(cell.content) }
        headers.each_with_index { |h, i| result[h] = cols[i] }

        result
      end

      {
        carrier: 'DHL',
        status: status,
        events: updates,
      }
    end

    def clean(text)
      text.gsub!(/\t|\n?/, '')
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

    def fedex id
      url = "https://www.fedex.com/trackingCal/track"

      uri = URI.parse(url)
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
        carrier: carrier,
        status: status,
        events: events
      }
    end

    private

    def contains_alpha_characters string
      !!/[^0-9]/.match(string)
    end

    # determines the shipping method of the id
    def shipping_method id
      return nil if contains_alpha_characters(id)

      case id.length
      when 12
        return :dhl
      when 34
        return :fedex
      end
    end


  end
end
