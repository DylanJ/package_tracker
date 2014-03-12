PackageTracker::Engine.routes.draw do
  post '/' => 'application#track', as: :track
end
