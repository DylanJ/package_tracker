module PackageTracker
  module TrackerHelper
    def tracker_button(id="123")
      modal_id = "modal#{Object.new.hash}"
      render('package_tracker/tracking/modal', modal_id: modal_id)
    end
  end
end
