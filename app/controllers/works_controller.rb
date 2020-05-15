class WorksController < ApplicationController
  def index
    @works = Work.all
    @movies = Work.where(category: :movie)
  end
end
