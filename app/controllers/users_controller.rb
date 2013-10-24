class UsersController < ApplicationController
  before_action :find_users, only: :index
  before_action :find_user, only: [:destroy, :update]

  def index
    @user = User.new
  end

  def create
    @user = User.new params_user
    if @user.save
      redirect_to users_path, :notice => "User created with email #{@user.email}"
    else
      find_users
      render "index"
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = "#{@user.name} deleted successfully"
    else
      flash[:notice] = "#{@user.name} could not deleted"
    end
    redirect_to users_path
  end

  private
    def params_user
      params.require(:user).permit(:email, :name)
    end

    def find_users
      @users = User.order("created_at desc")
    end

    def find_user
      @user = User.where(id: params[:id]).first
      redirect_to :back, :notice => "There is no user with id: #{params[:id]}" unless @user
    end
end
