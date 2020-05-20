class UsersController < ApplicationController
  def login_form
    @user = User.new
  end

  def login
    user = User.find_by(username: params[:user][:username])
    if user.nil?
      # new user
      user = User.create(username: params[:user][:username])
      if !user.save
        flash[:error] = "Unable to login"
        redirect_to root_path
        return
      end
      flash[:welcome] = "Successfully created new user #{user.username} with ID #{user.id} "
    else
      # existing user
      flash[:welcome] = "Successfully logged in as existing user #{user.username}"
    end

    session[:user_id] = user.id
    # session[:user] = user
    redirect_to root_path
  end

  def logout
    if session[:user_id]
      user = User.find_by(id: session[:user_id])
      unless user.nil?
        session[:user_id] = nil
        flash[:notice] = "Successfully logged out"
      else
        session[:user_id] = nil
        flash[:notice] = "Error Unknown User"
      end
    else
      flash[:error] = "You must be logged in to log out"
    end
    redirect_to root_path
  end

  # def current
  #   @user = User.find_by(id: session[:user_id])
  #   if @user.nil?
  #     flash[:error] = "You must be logged in to view this page"
  #     redirect_to root_path
  #     return
  #   end
  # end

  def index
    # if params[:author_id]
    #   # This is the nested route, /author/:author_id/books
    #   @author = Author.find_by(id: params[:author_id])
    #   @books = @author.books

    # else
      @users = User.all.order(:created_at)
    # end
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      head :not_found
      return
    end
  end


end
