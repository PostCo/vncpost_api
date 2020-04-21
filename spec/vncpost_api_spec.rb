RSpec.describe VNCPostAPI do
  let(:order) do
    VNCPostAPI::Order.new({
      code: "P360-4344",
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
      return_city: nil,
      return_district: nil,
      return_ward: nil,
      return_name: nil,
      return_phone_number: nil
    })
  end
  it "has a version number" do
    expect(VNCPostAPI::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
