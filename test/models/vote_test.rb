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
end
