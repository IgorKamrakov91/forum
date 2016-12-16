class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def import
    count = User.import params[:file]
    redirect_to users_path, notice: "Imported #{count} users"
  end
end
