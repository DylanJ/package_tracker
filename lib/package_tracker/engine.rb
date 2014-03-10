require 'package_tracker/config'

module PackageTracker
  class Engine < ::Rails::Engine
    isolate_namespace PackageTracker

    initializer "package_tracker.load_config" do
      PackageTracker::Config.load_config
    end
  end
end
