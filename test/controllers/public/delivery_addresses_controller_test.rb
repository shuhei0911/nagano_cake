require "test_helper"

class Public::DeliveryAddressesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get public_delivery_addresses_edit_url
    assert_response :success
  end

  test "should get index" do
    get public_delivery_addresses_index_url
    assert_response :success
  end
end
