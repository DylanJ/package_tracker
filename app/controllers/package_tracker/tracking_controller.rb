require_dependency "package_tracker/application_controller"

module PackageTracker
  class TrackingController < ApplicationController
    def track
      tracker = PackageTracker::Tracker.new
      result = tracker.track(params[:id])

      render json: result.to_json
    end
  end
end
