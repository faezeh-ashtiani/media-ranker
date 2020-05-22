require "test_helper"

describe User do
  before do
    @user = User.new({ username: "Oscar Baloney" })
  end
  
  it "can be instantiated" do
    expect(@user.valid?).must_equal true
  end

  it "will have the required fields" do
    @user.save
    user = User.find_by(username: "Oscar Baloney")
    [:username].each do |field|
      expect(user).must_respond_to field
    end
  end

  describe 'validations' do
    it 'is valid when all fields are present' do
      @user.save
      result = @user.valid?
      expect(result).must_equal true
    end

    it 'is invalid without a username' do
      @user.username = nil
      @user.save
      result = @user.valid?
      expect(result).must_equal false
      expect(@user.errors.messages).must_include :username
      expect(@user.errors.messages[:username]).must_include "can't be blank"
    end

    it 'username validation when the title already exists' do
      @user.save
      new_user = User.new({ username: "Oscar Baloney" })
     
      new_user.save
      expect(new_user.valid?).must_equal false
      expect(new_user.errors.messages).must_include :username
      expect(new_user.errors.messages[:username]).must_include "has already been taken"
    end
  end

  describe "relationships" do
    it "can have many votes" do
      user = users(:user_1)
      expect(user.votes.count).must_equal 6
      user.votes.each do |vote|
        expect(vote).must_be_instance_of Vote
      end
    end

    it "can have many works through votes" do
      user = users(:user_3)
      expect(user.works.count).must_equal 2
      user.works.each do |work|
        expect(work).must_be_instance_of Work
      end
    end
  end

end
