module VNCPostAPI
  # Tracking is only available on production
  class Tracking < Base
    self.prefix = "/Track/Order"
    self.element_name = ""
    self.connection_class = VNCPostAPI::Connection

    def self.find(code)
      body = {
        Code: code
      }
      connection.bearer_token = UserLogin.get_bearer_token(username: "V9Cus327141793", password: "8DBNvF9Y56nnjNTU")
      response = connection.post(collection_path, body.to_json)
      new(self.format.decode(response.body).deep_transform_keys!(&:underscore))
    end
  end
end
