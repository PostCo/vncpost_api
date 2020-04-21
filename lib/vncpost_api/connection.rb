module VNCPostAPI
  class Connection < ActiveResource::Connection

    private

    def request_failed?(response)
      body = JSON.parse(response.body)
      body["Result"] == 2
    end

    def handle_response(response)
      raise(ResourceInvalid.new(response)) if request_failed?(response)

      super
    end
  end
end
