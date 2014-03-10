module PackageTracker
  module Config
    def self.load_config
      config_file = File.join(Rails.root, 'config', 'package_tracker.yml')

      raise "PACKAGE TRACKER: required config/package_tracker.yml missing" unless File.exists?(config_file)

      config = File.read(config_file)
      yaml = YAML.load(config)

      Rails.application.config.tracker = yaml
    end
  end
end
