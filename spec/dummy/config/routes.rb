Rails.application.routes.draw do
  mount PackageTracker::Engine => "/tracking"
  root to: 'dash#index'
end
