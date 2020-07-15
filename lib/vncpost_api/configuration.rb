module VNCPostAPI
  class Configuration
    attr_accessor :testing, :username, :password
    alias_method :testing?, :testing
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
    if config.testing?
      VNCPostAPI::Base.site = "http://api.v3.vncpost.com"
      VNCPostAPI::Tracking.site ="https://pt.v.vncpost.com"
    else
      VNCPostAPI::Base.site = "http://u.api.vncpost.com"
      VNCPostAPI::Tracking.site = "https://pt.vncpost.com"
    end
  end
end
