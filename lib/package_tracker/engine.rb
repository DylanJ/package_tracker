module PackageTracker
  class Engine < ::Rails::Engine
    isolate_namespace PackageTracker

    initializer "package_tracker.load_helpers" do
      ActiveSupport.on_load :action_controller do
        helper PackageTracker::TrackerHelper
      end
    end

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.assets false
      g.helper false
    end
  end
end
