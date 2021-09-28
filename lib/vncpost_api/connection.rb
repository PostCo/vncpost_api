module VNCPostAPI
  class ResourceInvalid < ActiveResource::ClientError
    def to_s
      body = JSON.parse(response.body)
      if body["Message"]
        message = "Failed.".dup
        message << " Message: #{body["Message"]}"
        message
      else
        super
      end
    end
  end

  class Connection < ActiveResource::Connection
    private

    def request_failed?(response)
      body = JSON.parse(response.body)
      body["Result"] == 2
    rescue JSON::ParserError
      false
    end

    def handle_response(response)
      raise(ResourceInvalid.new(response)) if request_failed?(response)
      super
    end
  end
end
