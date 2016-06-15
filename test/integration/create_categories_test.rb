require 'test_helper'

class CreateCategoriesTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = User.create(username: "John", email: "john@example.com", password: "password", admin: true)
    @category = Category.create(name: "programming")
  end
  
  test "get new category form and create category" do
    sign_in_as(@user, "password")
    get new_category_path
    assert_template 'categories/new'
    assert_difference 'Category.count', 1 do
      post_via_redirect categories_path, category: {name: "sports"}
    end
    assert_template 'categories/index'
    assert_match "sports", response.body
  end
  
  test "invalid category submition results in failure" do
    sign_in_as(@user, "password")
    get new_category_path
    assert_template 'categories/new'
    assert_no_difference 'Category.count' do
      post categories_path, category: {name: " "}
    end
    assert_template 'categories/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "edit category name" do
    sign_in_as(@user, "password")
    get edit_category_path(id: 1)
    assert_template 'categories/edit'
    patch_via_redirect edit_categories_path, category: {id: '1', name: "program"}
    assert_template 'categories/index'
    assert_match "program"
  end
  
end