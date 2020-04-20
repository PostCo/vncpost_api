def set_config
  VNCPostAPI.configure do |config|
    config.api_host = ENV["VNCPOST_API_HOST"]
    config.username = ENV["VNCPOST_USERNAME"]
    config.password = ENV["VNCPOST_PASSWORD"]
  end
end
set_config
