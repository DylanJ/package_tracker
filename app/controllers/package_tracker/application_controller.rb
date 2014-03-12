module PackageTracker
  class ApplicationController < ActionController::Base
    def track
      tracker = PackageTracker::Tracker.new
      result = tracker.track(params[:id])

      render json: result.to_json
    end
  end
end
