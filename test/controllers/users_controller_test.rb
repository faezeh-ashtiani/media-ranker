require "test_helper"

describe UsersController do
  describe "login_form" do
    # get users_login_form_url
    # must_respond_with :success
  end

  describe "login" do
    # get users_login_url
    # must_respond_with :success
  end

  describe "logout" do
    # get users_logout_url
    # must_respond_with :success
  end

  describe "index" do
    it "responds with success when there are many users saved" do
      get "/users"
      must_respond_with :success
    end

    it "responds with success when there are no users saved" do
      User.all.each do |user|
        user.destroy
      end
      get "/users"
      must_respond_with :success
    end

  end
  
  describe "show" do
    it "responds with success when showing an existing valid user" do
      valid_user = users(:user_1)
      get "/users/#{valid_user.id}"
      must_respond_with :success
    end

    it "responds with 404 with an invalid work id" do
      invalid_id = -1
      get "/users/#{invalid_id}"
      must_respond_with :not_found
    end
  end

end
