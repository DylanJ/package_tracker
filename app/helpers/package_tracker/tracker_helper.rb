module PackageTracker
  module TrackerHelper
    def tracker_button id
      modal_id = "modal#{Object.new.hash}"
      render('package_tracker/tracking/modal', modal_id: modal_id, id: id)
    end
  end
end
