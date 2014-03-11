PackageTracker::Engine.routes.draw do
  post '/' => 'tracking#track', as: :track
end
