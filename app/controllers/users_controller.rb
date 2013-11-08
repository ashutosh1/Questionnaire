class UsersController < ApplicationController
  load_resource only: [:destroy, :update, :show]
  authorize_resource

  def index
    if params[:type] == "deleted"
      @users = User.deleted.order('created_at desc')
    else
      find_users
    end
    @user = User.new
    build_roles_users
  end

  def create
    @user = User.new params_user
    if @user.save
      redirect_to users_path, :notice => "User created with email #{@user.email}"
    else
      find_users_and_build_roles
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = "#{@user.name} deleted successfully"
    else
      flash[:alert] = "#{@user.name} could not deleted"
    end
    redirect_to users_path
  end

  def show
    return redirect_to request.referrer if !request.xhr?
    return flash.now[:alert] = "You can not edit your roles" if @user.id == current_user.id
    build_roles_users
  end

  def update
    if @user.update_attributes(params_user)
      redirect_to users_path, :notice => "User with email #{@user.email} has been updated successfully"
    else
      find_users_and_build_roles
    end
  end

  private
    def params_user
      params.require(:user).permit(:email, :roles_users_attributes => [:id, :role_id, :_destroy])
    end

    def find_users
      @users = User.not_deleted.order("created_at desc")
    end

    def build_roles_users
      # CR_Priyank: This can be moved to model
      if (@roles_users = @user.roles_users + Role.where(["id NOT IN (?)", @user.roles_users.collect(&:role_id)]).collect { |role| role.roles_users.build }).blank?
        @roles_users = Role.all.collect{|role| role.roles_users.build }
      end
    end

    def find_users_and_build_roles
      find_users
      build_roles_users
      # CR_Priyank: Its confusing to use render in filter instead we can move this to action
      render :index
    end
end
