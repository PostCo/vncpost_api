module VNCPostAPI
  class Configuration
    attr_accessor :testing, :username, :password
    alias_method :testing?, :testing
  end

  class << self
    def config
      @config ||= Configuration.new
    end

    def configure
      yield config

      after_configure
    end

    private

    def after_configure
      if config.testing?
        VNCPostAPI::Base.site = "http://api.v3.vncpost.com"
        VNCPostAPI::UserLogin.site = "http://api.v3.vncpost.com"
      else
        VNCPostAPI::Base.site = "https://u.api.vncpost.com"
        VNCPostAPI::UserLogin.site = "https://u.api.vncpost.com"
      end
      # Tracking is only available on production
      VNCPostAPI::Tracking.site = "http://pt.vncpost.com"

      return unless defined?(Rails) && Rails.respond_to?(:cache) && Rails.cache.is_a?(ActiveSupport::Cache::Store)

      VNCPostAPI.cache = Rails.cache
    end
  end
end
