require "test_helper"

describe Vote do
 
  before do
    @work = works(:work_5)
    @user = users(:user_2)
    @vote = Vote.new(
      {
        work_id: @work.id,
        user_id: @user.id
      }
    )
  end
  
  it "can be instantiated" do
    expect(@vote.valid?).must_equal true
  end

  it "will have the required fields" do
    @vote.save
    vote = Vote.last
    [:user_id, :work_id].each do |field|
      expect(vote).must_respond_to field
    end
  end

  describe 'validations' do
    it 'is valid when all fields are present' do
      @vote.save
      result = @vote.valid?
      expect(result).must_equal true
    end

    it 'is invalid without a user id' do
      @vote.user_id = nil
      @vote.save
      result = @vote.valid?
      expect(result).must_equal false
      expect(@vote.errors.messages).must_include :user_id
      expect(@vote.errors.messages[:user_id]).must_include "can't be blank"
    end

    it 'is invalid without a work_id' do
      @vote.work_id = nil
      @vote.save
      result = @vote.valid?
      expect(result).must_equal false
      expect(@vote.errors.messages).must_include :work_id
      expect(@vote.errors.messages[:work_id]).must_include "can't be blank"
    end

    it 'fails validation when the work_id alreadt exists with the same user_id' do
      @vote.save
      new_vote = Vote.new(
        {
          work_id: @work.id,
          user_id: @user.id
        }
      )
      new_vote.save
      expect(new_vote.valid?).must_equal false
      expect(new_vote.errors.messages).must_include :work_id
      expect(new_vote.errors.messages[:work_id]).must_include "has already been taken"
    end
  end

  describe "relationships" do
    it "has one work and one user" do
      @vote.save
      expect(@vote.work_id).must_equal @work.id
      expect(@vote.work).must_be_instance_of Work
      expect(@vote.user_id).must_equal @user.id
      expect(@vote.user).must_be_instance_of User
    end
  end
end
