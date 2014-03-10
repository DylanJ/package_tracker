PackageTracker::Engine.routes.draw do
  post '/' => 'tracking#track'
end
