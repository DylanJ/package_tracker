module PackageTracker
  module Tracker
    module DHL
      IDLength = 12
      StatusRow = 2         # third row in tbody
      StatusTextCell = 2    # third cell in <td>
      StatusTextElement = 2 # "text<br>status"
      Headers = [:date, :location, :status]

      def self.lookup id
        lang = I18n.locale.to_s
        url = "http://nolp.dhl.de/nextt-online-public/set_identcodes.do?lang=#{lang}&idc=#{id}&extendedSearch=true"
        doc = Nokogiri::HTML(open(url))

        dhl_table = doc.css('table')

        if dhl_table.empty?
          return { response: 'failure', message: I18n.t('package_tracker.no_id') }
        end

        raw_status = dhl_table.css('tbody tr')[StatusRow].css('td')[StatusTextCell].children[StatusTextElement].content
        status = clean(raw_status)

        updates_table = doc.css('table table')
        updates = updates_table.css('tbody tr').map do |row|
          result = {}
          cols = row.css('td').map { |cell| clean(cell.content) }
          Headers.each_with_index { |h, i| result[h] = cols[i] }

          result
        end

        {
          response: 'success',
          carrier: 'DHL',
          status: status,
          events: updates,
        }
      end

      # strip tabs and newlines
      def self.clean(text)
        text.gsub!(/\t|\n?/, '')
      end
    end
  end
end

