class WorksController < ApplicationController
  def index
    @works = Work.all
    @albums = Work.top_works("album")
    @books = Work.top_works("book")
    # @books = Work.where(category: :book)
    @movies = Work.top_works("movie")
    # @movies = Work.where(category: :movie)
  end

  def show
    work_id = params[:id]
    @work = Work.find_by(id: work_id)
    if @work.nil?
      head :not_found
      return
    end
  end
end
