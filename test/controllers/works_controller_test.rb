require "test_helper"

describe WorksController do
  describe "index" do
    it "responds with success when there are many works saved" do
      get "/works"
      must_respond_with :success
    end

    it "responds with success when there are no works saved" do
      Work.all.each do |work|
        work.destroy
      end
      get "/works"
      must_respond_with :success
    end

  end
  
  describe "show" do
    it "responds with success when showing an existing valid work" do
      valid_work = works(:work_1)
      get "/works/#{valid_work.id}"
      must_respond_with :success
    end

    it "responds with 404 with an invalid work id" do
      invalid_id = -1
      get "/works/#{invalid_id}"
      must_respond_with :not_found
    end
  end

  describe "new" do
    it "responds with success" do
      Work.new(
        {
          title: "Test title"
        }
      )

      get "/works/new"
      must_respond_with :success
    end
  end

  describe "create" do
    let (:work_hash) {
      {
        work: {
          category: "movie",
          title: "He is just not that into you!",
          creator: "That Guy",
          publication_year: 2009,
          description: "Cheesy RomCom with attractive actors and accresses"
        }
      }
    }

    it "can create a new work with valid information accurately, and redirect" do
      expect {
        post works_path, params: work_hash
      }.must_differ 'Work.count', 1
      
      saved_work = Work.find_by(title: "He is just not that into you!")
      must_redirect_to work_path(saved_work.id)
      expect(saved_work.category).must_equal work_hash[:work][:category]
      expect(saved_work.title).must_equal work_hash[:work][:title]
      expect(saved_work.creator).must_equal work_hash[:work][:creator]
      expect(saved_work.publication_year).must_equal work_hash[:work][:publication_year]
      expect(saved_work.description).must_equal work_hash[:work][:description]
    end

    it "does not create a work if the form data violates Work validations with no title, and responds with bad_request" do
      work_hash[:work][:title] = nil
      expect {
        post works_path, params: work_hash
      }.must_differ "Work.count", 0
      must_respond_with :bad_request
    end

    it "does not create a work if the form data violates Work validations with same title and same catagory, and responds with bad_request" do
      work_hash = {
        work:
        {
          category: "album",
          title: "Wake-up Pie"
        }
      }
  
      expect {
        post works_path, params: work_hash
      }.must_differ "Work.count", 0
      must_respond_with :bad_request
    end
  end

  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid work" do
      work_id = Work.find_by(title: "Bad Moms").id
      get "/works/#{work_id}/edit"
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing work" do
      invalid_id = -1
      get "/works/#{invalid_id}/edit"
      must_respond_with :not_found
    end
  end

  describe "update" do
    let (:work_hash) {
      {
        work: {
          category: "book",
          title: "Gifts of Imperfection",
          creator: "Brene Brown",
          publication_year: 2010,
          description: "How to ve brave and volnurable"
        }
      }
    }

    it "can update an existing work with valid information accurately, and redirect" do

      work_id = Work.find_by(title: "Winter Pie").id

      expect {
        patch work_path(work_id), params: work_hash
      }.wont_change "Work.count"

      work = Work.find_by(id: work_id)
      expect(work.category).must_equal work_hash[:work][:category]
      expect(work.title).must_equal work_hash[:work][:title]
      expect(work.creator).must_equal work_hash[:work][:creator]
      expect(work.publication_year).must_equal work_hash[:work][:publication_year]
      expect(work.description).must_equal work_hash[:work][:description]

      must_redirect_to work_path(work_id)
    end

    it "does not update any work if given an invalid id, and responds with a 404" do
      invalid_id = -1
      expect {
        patch work_path(invalid_id), params: work_hash
      }.wont_change "Work.count"
      must_respond_with :not_found
    end

    it "does not update a work if the form data violates Work validations with no title, and responds with a redirect" do
      work_id = Work.find_by(title: "Wake-up Pie").id
      work_hash[:work][:title] = nil
      
      expect {
        patch work_path(work_id), params: work_hash
      }.wont_change "Work.count"
      must_respond_with :bad_request
    end
  end

  describe "destroy" do
    it "destroys the work instance in db when work exists, then redirects" do
      work_id = Work.find_by(title: "Bad Moms").id
      expect {
        delete work_path(work_id)
      }.must_differ "Work.count", -1
      must_redirect_to root_path
    end

    it "does not change the db when the work does not exist, then responds with not found" do
      invalid_id = -1
      expect {
        delete work_path(invalid_id)
      }.wont_change "Work.count"
      must_respond_with :not_found
    end
  end

end
