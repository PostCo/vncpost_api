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
        test_site = "http://sgp-seaedi-test.800best.com"
        VNCPostAPI::Base.site = test_site
        VNCPostAPI::UserLogin.site = test_site
      else
        production_site = "http://sgp-seaedi.800best.com"
        VNCPostAPI::Base.site = production_site
        VNCPostAPI::UserLogin.site = production_site
      end
      # Tracking is only available on production
      VNCPostAPI::Tracking.site = "http://pt.vncpost.com"

      return unless defined?(Rails) && Rails.respond_to?(:cache) && Rails.cache.is_a?(ActiveSupport::Cache::Store)

      VNCPostAPI.cache = Rails.cache
    end
  end
end
