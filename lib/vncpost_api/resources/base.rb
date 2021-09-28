module VNCPostAPI
  class Base < ::ActiveResource::Base
    self.include_root_in_json = false
    self.include_format_in_path = false
    self.connection_class = VNCPostAPI::Connection
    self.auth_type = :bearer

    def create
      connection.bearer_token = UserLogin.bearer_token
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

    def format_before_send_request
      @attributes.deep_transform_keys!(&:camelcase)
    end

    def reset_attributes_format
      @attributes.deep_transform_keys!(&:underscore)
    end

    def load_attributes_from_response(response)
      super
      reset_attributes_format
    end
  end
end
