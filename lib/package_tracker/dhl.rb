module PackageTracker
  module Tracker
    module DHL
      def self.lookup id
        status_row = 2          # third row in tbody
        status_text_cell = 2    # third cell in <td>
        status_text_element = 2 # "text<br>status"

        url = "http://nolp.dhl.de/nextt-online-public/set_identcodes.do?lang=#{I18n.locale.to_s}&idc=#{id}&extendedSearch=true"
        doc = Nokogiri::HTML(open(url))

        dhl_table = doc.css('table')

        if dhl_table.empty?
          return { response: 'failure', message: I18n.t('package_tracker.no_id') }
        end

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
          response: 'success',
          carrier: 'DHL',
          status: status,
          events: updates,
        }
      end

      def self.clean(text)
        text.gsub!(/\t|\n?/, '')
      end

    end
  end
end

