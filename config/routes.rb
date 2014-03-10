PackageTracker::Engine.routes.draw do
  post '/' => 'tracking#track'
  get '/' => 'tracking#track'
end
