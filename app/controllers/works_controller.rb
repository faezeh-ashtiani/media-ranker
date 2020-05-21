class WorksController < ApplicationController

  before_action :find_work, only: [:show, :edit, :update, :destroy]

  def index
    @movies = Work.where(category: :movie).sort{ |a, b| b.votes.count <=> a.votes.count }
    @books = Work.where(category: :book).sort{ |a, b| b.votes.count <=> a.votes.count }
    @albums = Work.where(category: :album).sort{ |a, b| b.votes.count <=> a.votes.count }
  end

  def show
    if @work.nil?
      head :not_found
      return
    end
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)
    if @work.save 
      flash[:success] = "Successfully created #{@work.category} #{@work.id}"
      redirect_to work_path(@work.id) 
      return
    else
      flash.now[:warning] = [ "A problem occurred: Could not create #{@work.category}" ]
      if @work.errors.any?
        @work.errors.each << flash[:warning]
      end
      render :new, status: :bad_request
      return
    end
  end

  def edit
    if @work.nil?
      head :not_found
      return
    end
  end

  def update
    if @work.nil?
      head :not_found
      return
    elsif @work.update(work_params)
      flash[:success] = "Successfully updated #{@work.category} #{@work.id}"
      redirect_to work_path(@work.id)
      return
    else 
      flash.now[:warning] = "A problem occurred: Could not update #{@work.category}"
      render :edit, status: :bad_request
      return
    end
  end

  def destroy
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
