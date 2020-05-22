require "test_helper"

describe Work do

  before do
    @work_album = Work.new(
      {
        category: "album",
        title: "21",
        creator: "Adele",
        publication_year: 2011,
        description: "Awesome songs by The great Adele"
      }
    )
  end
  
  it "can be instantiated" do
    expect(@work_album.valid?).must_equal true
  end

  it "will have the required fields" do
    @work_album.save
    work = Work.find_by(title: "21")
    [:category ,:title, :creator, :publication_year, :description].each do |field|
    expect(work).must_respond_to field
    end
  end

  describe 'validations' do
    # before do
    #   @work_album = Work.new(
    #     {
    #       category: "album",
    #       title: "21",
    #       creator: "Adele",
    #       publication_year: 2011,
    #       description: "Awesome songs by The great Adele"
    #     }
    #   )
    # end

    it 'is valid when all fields are present' do
      @work_album.save
      result = @work_album.valid?
      expect(result).must_equal true
    end

    it 'is invalid without a title' do
      @work_album.title = nil
      @work_album.save
      result = @work_album.valid?
      expect(result).must_equal false
      expect(@work_album.errors.messages).must_include :title
      expect(@work_album.errors.messages[:title]).must_include "can't be blank"
    end

    it 'fails validation when the title alreadt exists in the same category' do
      @work_album.save
      new_work = Work.new(
        {
          category: "album",
          title: "21",
        }
      )
      new_work.save
      expect(new_work.valid?).must_equal false
      expect(new_work.errors.messages).must_include :title
      expect(new_work.errors.messages[:title]).must_include "has already been taken"
    end
  end

  describe "relationships" do
    it "can have many votes" do
      work = works(:work_3)
      expect(work.votes.count).must_equal 4
      work.votes.each do |vote|
        expect(vote).must_be_instance_of Vote
      end
    end

    it "can have many users through votes" do
      work = works(:work_2)
      expect(work.users.count).must_equal 2
      work.users.each do |user|
        expect(user).must_be_instance_of User
      end
    end
  end

  describe "custom methods" do
    describe "top works" do
      it "can pick max 10 top works in each category" do
        category = "album"
        top_albums = Work.top_works(category)
        expect(top_albums.count).must_be :<=, 10
        expect(top_albums.count).must_equal 3

        phrase = top_albums[0].votes.count >= top_albums[1].votes.count  
        expect(phrase).must_equal true
      end

    end

    describe "spotlight" do

      it "can pick the work in each catagory with maximum votes" do
        spotlight = Work.spotlight
        expect(spotlight).must_equal works(:work_3)
        votes_count = []
        works.each do |work|
          votes_count << work.votes.count
        end
        work_3_votes = works(:work_3).votes.count
        expect(votes_count.max).must_equal work_3_votes
      end
      
      it "if there is a tie with votes, it picks the most recent" do
        vote_14 = Vote.create(work_id: works(:work_4).id, user_id: users(:user_4).id)
        # puts vote_14.valid? => true
        spotlight = Work.spotlight
        expect(spotlight).must_equal works(:work_4)
      end

    end

  end
end
