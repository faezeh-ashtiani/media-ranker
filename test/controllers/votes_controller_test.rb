require "test_helper"

describe VotesController do
  describe "create" do
    it "can vote with a logged-in user, and redirect" do
      login()
      work = works(:work_1)
      expect{
        post work_votes_path(work.id)
      }.must_differ "Vote.count", 1
      vote = Vote.last
      must_respond_with :redirect
      expect(vote.user).wont_be_nil
      expect(session[:user_id]).must_equal vote.user.id
    end

    it "can not vote for the same work with the same user twice" do
      login()
      work_id = works(:work_1).id
      user_id = User.find_by(id: session[:user_id]).id
      Vote.create(work_id: work_id, user_id: user_id)
      expect{
        post work_votes_path(work_id)
      }.wont_change "Vote.count"
      must_respond_with :redirect
    end

    it "can not vote with no user logged in, and redirect" do
      work = works(:work_1)
      expect{
        post work_votes_path(work.id)
      }.wont_change "Vote.count"
      must_respond_with :redirect
      expect(session[:user_id]).must_be_nil
    end
  end

end
