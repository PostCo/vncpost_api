module VNCPostAPI
  class Order < Base
    validates :code, :product_name, :collect_amount, :weight, :width, :height, :length,
      :source_address, :source_city, :source_district, :source_ward, :source_name, :source_phone_number,
      :dest_city, :dest_district, :dest_ward, :dest_name, :dest_phone_number, :dest_address, presence: true

    validates :journey_type, inclusion: {
      in: [1, 2, 3],
      message: "%{value} is not a supported journey type, supported journey types are 1(Delivery), 2(Exchange), 3(Collect)"
    }
    validates :service_id, inclusion: {
      in: [12490, 12491],
      message: "%{value} is not a supported service id, supported service ids are 12490(Express), 12491(Eco)"
    }

    DEFAULT_ATTRS = {
      code: nil,
      product_name: "Fashion Apparel",
      collect_amount: 0,
      journey_type: 1,
      service_id: 12490,
      weight: 0,
      width: 0,
      height: 0,
      length: 0,
      note: nil,
      source_address: nil,
      source_city: nil,
      source_district: nil,
      source_ward: nil,
      source_name: nil,
      source_phone_number: nil,
      dest_address: nil,
      dest_city: nil,
      dest_district: nil,
      dest_ward: nil,
      dest_name: nil,
      dest_phone_number: nil,
      return_address: nil,
      return_city: nil,
      return_district: nil,
      return_ward: nil,
      return_name: nil,
      return_phone_number: nil
    }

    self.prefix = "/Order/Add"
    self.element_name = ""

    def self.track(code)
      new(code: code).track
    end

    def initialize(attributes = {}, persisted = false)
      attributes = DEFAULT_ATTRS.merge(attributes)
      super
      # set_service_id
    end

    def track
      puts "#track only available in production environment"
      self.class.retrieve_token
      tracking_number = @attributes[:returned_code] || @attributes[:code]
      get("Track/#{tracking_number}")
    end

    private

    def load_attributes_from_response(response)
      # save the response attributes
      if response_code_allows_body?(response.code.to_i) &&
          (response["Content-Length"].nil? || response["Content-Length"] != "0") &&
          !response.body.nil? && response.body.strip.size > 0

        attributes = self.class.format.decode(response.body)
        # Code(client provided code) will be overwrited by response's Code from the server
        # To avoid that, the code returned will be stored as ReturnedCode
        attributes["ReturnedCode"] = attributes.delete("Code")

        load(attributes, false, true)
        # reset the attributes structure after assign attributes that came back from server
        reset_attributes_format
        @persisted = true
      end
    end
  end
end
