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
        flash[:warning] = "Unable to login"
        redirect_to root_path
        return
      end
      flash[:success] = "Successfully created new user #{user.username} with ID #{user.id} "
    else
      # existing user
      flash[:success] = "Successfully logged in as existing user #{user.username}"
    end

    session[:user_id] = user.id
    redirect_to root_path
  end

  def logout
    if session[:user_id]
      user = User.find_by(id: session[:user_id])
      unless user.nil?
        session[:user_id] = nil
        flash[:success] = "Successfully logged out"
      else
        session[:user_id] = nil
        flash[:warning] = "Error Unknown User"
      end
    else
      flash[:warning] = "You must be logged in to log out"
    end
    redirect_to root_path
  end

  def index
    @users = User.all.order(:created_at)
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      head :not_found
      return
    end
  end

end
