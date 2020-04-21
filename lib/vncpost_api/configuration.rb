module VNCPostAPI
  class Configuration
    attr_accessor :api_host, :username, :password
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.config=(config)
    @config = config
  end

  def self.configure
    yield config
    # set the site once user configure
    VNCPostAPI::Base.site = VNCPostAPI.config.api_host
  end
end
