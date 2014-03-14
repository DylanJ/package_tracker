module PackageTracker
  module TrackerHelper
    def track_shipment id=nil
      if id.present?
        render('package_tracker/tracking/results', id: id)
      else
        render('package_tracker/tracking/modal', modal_id: modal_id)
      end
    end

    def modal_id
      "modal#{Object.new.hash}"
    end
  end
end
