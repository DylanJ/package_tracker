Rails.application.routes.draw do

  mount PackageTracker::Engine => "/package_tracker"
end
