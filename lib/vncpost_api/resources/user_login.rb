require "jwt"

module VNCPostAPI
  class UserLogin < ::ActiveResource::Base
    self.include_root_in_json = false
    self.include_format_in_path = false
    self.prefix = "/User/Login"
    self.element_name = ""

    class << self
      def bearer_token(username: VNCPostAPI.config.username, password: VNCPostAPI.config.password)
        cache_key = "VNCPostAPI/bearer_token"
        cached_token = VNCPostAPI.cache.read(cache_key)
        return cached_token if cached_token

        token = create(Username: username, Password: password).token
        VNCPostAPI.cache.write(
          cache_key,
          token,
          expires_in: expires_in(token) - 15 # clear cache earlier
        )

        token
      end

      private

      def expires_in(jwt)
        Time.at(JWT.decode(jwt, nil, false)[0]["exp"])
      end
    end
  end
end
