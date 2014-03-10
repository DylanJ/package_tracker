module PackageTracker
  module TrackerHelper
    def tracker_button(id="123")
      content_tag(:div, class: 'foo') do
        "hello world"
      end
    end
  end
end
