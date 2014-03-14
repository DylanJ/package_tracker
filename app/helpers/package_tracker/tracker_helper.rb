module PackageTracker
  module TrackerHelper
    def tracker_button id=nil
      render('package_tracker/tracking/modal', modal_id: modal_id, id: id)
    end

    def modal_id
      "modal#{Object.new.hash}"
    end
  end
end
