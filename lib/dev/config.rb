def set_config
  VNCPostAPI.configure do |config|
    config.testing = true 
    config.username = ENV["VNCPOST_USERNAME"]
    config.password = ENV["VNCPOST_PASSWORD"]
  end
end
