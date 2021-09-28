require "setup_helper"

RSpec.describe VNCPostAPI do
  it "has a version number" do
    expect(VNCPostAPI::VERSION).not_to be nil
  end

  describe "VNCPostAPI::Order" do
    let(:code) { "P360-4344" }
    let(:order) do
      VNCPostAPI::Order.new(
        code: "ABCD123",
        product_name: "Fashion Apparel",
        collect_amount: 0,
        journey_type: 1,
        service_id: 12490,
        weight: 1,
        width: 20,
        height: 5,
        length: 15,
        note: nil,
        source_address: "No. 10",
        source_city: "Hà Nội",
        source_district: "Quận Nam Từ Liêm",
        source_ward: "Phường Cầu Diễn",
        source_name: "Andy Chong",
        source_phone_number: "+84-355-5585-42",
        dest_address: "No. 12",
        dest_city: "Hà Nội",
        dest_district: "Huyện Thường Tín",
        dest_ward: "Xã Ninh Sở",
        dest_name: "Andy Chong",
        dest_phone_number: "+84-355-5585-42",
        return_city: "Hà Nội",
        return_district: "Huyện Thường Tín",
        return_ward: "Xã Ninh Sở",
        return_name: "Andy Chong",
        return_phone_number: "+84-355-5585-42"
      )
    end

    describe "validation" do
      context "success" do
        it { expect(order.valid?).to be true }
      end

      context "failure" do
        context "presences" do
          attrs = [:code, :product_name, :collect_amount, :weight, :width, :height, :length,
            :source_address, :source_city, :source_district, :source_ward, :source_name, :source_phone_number,
            :dest_city, :dest_district, :dest_ward, :dest_name, :dest_phone_number, :dest_address]

          attrs.each do |attr|
            before { order.send("#{attr}=", nil) }
            it do
              order.valid?
              expect(order.errors.messages.keys).to include(attr.to_s.to_sym)
            end
          end
        end
        context "service_id" do
          before { order.service_id = 5123 }
          it do
            order.valid?
            expect(order.errors.messages.keys).to include(:service_id)
          end
        end
        context "journey_type" do
          before { order.journey_type = 5 }
          it do
            order.valid?
            expect(order.errors.messages.keys).to include(:journey_type)
          end
        end
      end
    end

    describe "#save" do
      let(:token) { "abc1234567890" }
      let(:headers) do
        {
          "Authorization" => "Bearer #{token}",
          "Content-Type" => "application/json"
        }
      end
      let(:code) { "ABC123" }
      context "success" do
        let(:returned_code) { "84855004010378" }

        before do
          ActiveResource::HttpMock.respond_to do |mock|
            mock.post("/User/Login", {}, {token: token}.to_json, 200)
            mock.post("/Order/Add",
              headers,
              {
                Result: 1,
                Message: nil,
                Code: returned_code,
                RouteCode: "HH949-00-00-01"
              }.to_json,
              200)
          end
        end
        it do
          order.save
          expect(order.code).to eq(code)
        end
        it do
          order.save
          expect(order.returned_code).to eq(returned_code)
        end
      end

      context "failure" do
        context "login failed" do
          it do
            ActiveResource::HttpMock.respond_to do |mock|
              mock.post("/User/Login", {}, nil, 401)
            end
            expect { order.save }.to raise_error(ActiveResource::UnauthorizedAccess)
          end
        end
        context "order creation failed" do
          before do
            ActiveResource::HttpMock.respond_to do |mock|
              mock.post("/User/Login", {}, {token: token}.to_json, 200)
              mock.post("/Order/Add",
                headers,
                {
                  Result: 2,
                  Message: "Đơn hàng đã tồn tại trên hệ thống!",
                  Code: nil,
                  RouteCode: nil
                }.to_json,
                200)
            end
          end
          it { expect { order.save }.to raise_error(VNCPostAPI::ResourceInvalid) }
          it do
            order.save
          rescue VNCPostAPI::ResourceInvalid
            expect(order.code).to eq(code)
          end
        end
      end
    end
  end
end
