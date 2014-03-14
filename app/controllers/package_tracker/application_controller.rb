module PackageTracker
  class ApplicationController < ActionController::Base
    def track
      render json: PackageTracker::Tracker.lookup(params[:id]).to_json
    end
  end
end
