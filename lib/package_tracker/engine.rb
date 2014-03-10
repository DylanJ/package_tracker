require 'package_tracker/config'

module PackageTracker
  class Engine < ::Rails::Engine
    isolate_namespace PackageTracker

    initializer "package_tracker.load_config" do
      PackageTracker::Config.load_config
    end

    initializer "package_tracker.load_helpers" do
      ActiveSupport.on_load :action_controller do
        helper PackageTracker::TrackerHelper
      end
    end
  end
end
