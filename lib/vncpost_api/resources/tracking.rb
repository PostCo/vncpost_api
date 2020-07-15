module VNCPostAPI
  class Tracking < Base
    self.prefix = "/Track/Order"
    self.element_name = ""

    def self.find(code)
      body = {
        Code: code
      }

      self.retrieve_token
      
      response = connection.post(collection_path, body.to_json)
      new(self.format.decode(response.body).deep_transform_keys!(&:underscore))
    end
  end
end