require "test_helper"

describe UsersController do
  describe "login_form" do
    it "responds with success" do
      User.new({ username: "J Lo" })
      get "/login"
      must_respond_with :success
    end
  end

  describe "login" do
    it "can login a new user" do
      user = nil
      expect{
        user = login()
      }.must_differ "User.count", 1
      must_respond_with :redirect
      expect(user).wont_be_nil
      expect(session[:user_id]).must_equal user.id
      expect(user.username).must_equal "Grace Hopper"
    end

    it "can login an existing user" do
      user = User.create(username: "Ed Sheeran")
      expect{
        login(user.username)
      }.wont_change "User.count"
      expect(session[:user_id]).must_equal user.id
      must_respond_with :redirect
    end

    it "does not create a user if the form data violates Work validations with no username, and responds with bad_request" do
      user_hash = { user: { username: nil } }
      expect {
        post login_path, params: user_hash
      }.must_differ "Work.count", 0
      must_respond_with :redirect
    end

  end

  describe "logout" do
    it "can logout a logged in user" do
      login()
      expect(session[:user_id]).wont_be_nil

      post logout_path

      expect(session[:user_id]).must_be_nil
    end
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
