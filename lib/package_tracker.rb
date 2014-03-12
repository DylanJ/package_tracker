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

    def fedex id, carrier='fedex_ground'
      {
        carrier: 'FedEx',
        status: data.status.capitalize,
        events: data.shipment_events
      }
    end

  end
end
