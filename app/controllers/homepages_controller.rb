class HomepagesController < ApplicationController
  def index
    @albums = Work.top_works(:album)
    @books = Work.top_works("book")
    @movies = Work.top_works("movie")
  end
end
