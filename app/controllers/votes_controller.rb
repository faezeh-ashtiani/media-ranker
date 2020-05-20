class VotesController < ApplicationController
  def create
    # raise
    work = Work.find_by(id: params[:work_id])
    user = User.find_by(id: session[:user_id])
    if user 
      if work
        @vote = Vote.new(
          work_id: work.id,
          user_id: user.id
        )
        if @vote.save
          flash[:success] = "Successfully upvoted!"
        else
          flash[:warning] = ["A problem occurred: Could not upvote", "user: has already voted for this work"]
        end
      end
    else # no user logged in
      flash[:warning] = "A problem occurred: You must log in to do that"
    end
    redirect_to request.referrer || works_path
    # redirect_to work_path(work.id)
  end
end
