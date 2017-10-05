APP_CONFIG = YAML.load(File.read("#{Rails.root.to_s}/config/cadet_config.yml"))[Rails.env]
