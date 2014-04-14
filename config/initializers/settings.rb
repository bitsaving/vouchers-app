SETTINGS = YAML.load_file("#{Rails.root}/config/attachment.yml")[Rails.env]
bucket = SETTINGS["bucket"]
access_key = SETTINGS["access_key_id"]
secret_access = SETTINGS["secret_access_key"]