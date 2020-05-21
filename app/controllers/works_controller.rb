class WorksController < ApplicationController

  before_action :find_work, only: [:show, :edit, :update, :destroy]

  def index
    # if params[:author_id]
    #   # This is the nested route, /author/:author_id/books
    #   @author = Author.find_by(id: params[:author_id])
    #   @books = @author.books

    # else
      # @albums = Work.top_works("album")
      # @books = Work.top_works("book")
      # @movies = Work.top_works("movie")
      @movies = Work.where(category: :movie).sort{ |a, b| b.votes.count <=> a.votes.count }
      @books = Work.where(category: :book).sort{ |a, b| b.votes.count <=> a.votes.count }
      @albums = Work.where(category: :album).sort{ |a, b| b.votes.count <=> a.votes.count }
    # end
  end

  def show
    # work_id = params[:id]
    # @work = Work.find_by(id: work_id)
    if @work.nil?
      head :not_found
      return
    end
  end

  def new
    # if params[:author_id]
    #   # This is the nested route, /author/:author_id/books/new
    #   author = Author.find_by(id: params[:author_id])
    #   @book = author.books.new

    # else
      # This is the 'regular' route, /books/new
      @work = Work.new
    # end
  end

  def create
    @work = Work.new(work_params)
    if @work.save 
      flash[:success] = "Successfully created #{@work.category} #{@work.id}"
      redirect_to work_path(@work.id) 
      return
    else
      flash.now[:error] = "A problem occurred: Could not create #{@work.category}"
      render :new, status: :bad_request
      return
    end
  end

  def edit
    # if params[:author_id]
    #   # This is the nested route, /author/:author_id/books/new
    #   author = Author.find_by(id: params[:author_id])
    #   @book = author.books.new

    # else
      # This is the 'regular' route, /books/new
      # @work = Work.find_by(id: params[:id])

      if @work.nil?
        head :not_found
        return
      end
    # end
  end

  def update
    # @work = Work.find_by(id: params[:id])

    if @work.nil?
      head :not_found
      return
    elsif @work.update(work_params)
      flash[:success] = "Successfully updated #{@work.category} #{@work.id}"
      redirect_to work_path(@work.id)
      return
    else 
      flash.now[:error] = "A problem occurred: Could not update #{@work.category}"
      render :edit, status: :bad_request
      return
    end
  end

  def destroy
    # @work = Work.find_by(id: params[:id])
    if @work.nil?
      head :not_found
      return
    end
    flash[:success] = "Successfully destroyed #{@work.category} #{@work.id}"
    @work.destroy
    redirect_to root_path
    return
  end

  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end

  def find_work
    @work = Work.find_by_id(params[:id])
  end

end
