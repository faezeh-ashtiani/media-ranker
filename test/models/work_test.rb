require "test_helper"

describe Work do
  describe 'validations' do
    before do
      # Arrange
      # author = Author.new(name: 'test author')
      @work = Work.new(
        category: "movie",
        title: 'test work',
        creator: 'tester',
        publication_year: 1970,
        description: 'Incidunt molestias deserunt laudantium.'
      )
    end

    it 'is valid when all fields are present' do
      # Act
      result = @work.valid?

      # Assert
      expect(result).must_equal true
    end

    it 'is invalid without a title' do
      # Arrange
      @work.title = nil
    
      # Act
      result = @work.valid?
    
      # Assert
      expect(result).must_equal false
      expect(@work.errors.messages).must_include :title
      expect(@work.errors.messages[:title]).must_include "can't be blank"
    end

    it 'fails validation when the title alreadt exists' do
      Work.create(title: @work.title)
      expect(@work.valid?).must_equal false
      expect(@work.errors.messages).must_include :title
      expect(@work.errors.messages[:title]).must_include "has already been taken"
    end
  end

  describe "custom methods" do
    describe "top works" do
      it "can pick max 10 top works in each catagory" do

      end

    end

    describe "spotlight" do

      it "can pick the work with maximum votes" do

      end
      
      it "if there is a tie with votes, it picks the most recent" do

      end

    end

  end
end
