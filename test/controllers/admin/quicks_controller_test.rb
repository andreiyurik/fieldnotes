require "test_helper"

class Admin::QuicksControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:admin)
  end

  test "new renders quick post form" do
    get new_admin_quick_path
    assert_response :success
    assert_select "h1", "Quick Post"
  end

  test "create with title creates series and redirects to edit" do
    assert_difference("FieldSeries.count") do
      post admin_quick_path, params: {
        field_series: { title: "Airport Shots", location: "Bali, Indonesia" }
      }
    end

    series = FieldSeries.last
    assert_equal "photo", series.kind
    assert_equal "Airport Shots", series.title
    assert_equal "Bali, Indonesia", series.location
    assert_redirected_to edit_admin_field_path(series)
  end

  test "create with photos attaches them as field items" do
    photo = fixture_file_upload("test_image.jpg", "image/jpeg")

    assert_difference("FieldItem.count") do
      post admin_quick_path, params: {
        field_series: { title: "Quick Test", photos: [photo] }
      }
    end

    item = FieldItem.last
    assert_equal 1, item.position
    assert_equal "photo", item.kind
  end

  test "create without title fails" do
    assert_no_difference("FieldSeries.count") do
      post admin_quick_path, params: {
        field_series: { title: "", location: "Bali" }
      }
    end
    assert_response :unprocessable_entity
  end
end
