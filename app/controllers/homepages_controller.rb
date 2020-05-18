class HomepagesController < ApplicationController
  def index
    @movies = Work.where(category: :movie)
    @books = Work.where(category: :book)
    @albums = Work.where(category: :album)
  end
end
