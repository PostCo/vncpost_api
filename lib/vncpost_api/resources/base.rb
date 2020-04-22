module VNCPostAPI
  class Base < ::ActiveResource::Base
    self.include_root_in_json = false
    self.include_format_in_path = false
    self.connection_class = VNCPostAPI::Connection
    self.site = VNCPostAPI.config&.api_host

    def create
      self.class.retrieve_token
      format_before_send_request
      super
    rescue => e
      reset_attributes_format
      raise e
    end

    def update
      raise NotImplementedError, "#update is not supported"
    end

    def build
      raise NotImplementedError, "#build is not supported"
    end

    private

    def self.retrieve_token
      clear_auth_token
      if VNCPostAPI.config&.username && VNCPostAPI.config&.password
        response = connection.post("/User/Login", {
          Username: VNCPostAPI.config.username,
          Password: VNCPostAPI.config.password
        }.to_json)
        connection.auth_type = :bearer
        connection.bearer_token = JSON.parse(response.body)["token"]
      else
        raise ArgumentError, "Please set the username and password in the config file under the initializer dir"
      end
    end

    def self.clear_auth_token
      connection.auth_type = nil
      connection.bearer_token = nil
    end

    def format_before_send_request
      @attributes.transform_keys!(&:camelcase)
    end

    def reset_attributes_format
      @attributes.transform_keys!(&:underscore)
    end

    def load_attributes_from_response(response)
      super
      reset_attributes_format
    end
  end
end
