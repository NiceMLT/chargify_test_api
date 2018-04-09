class UsersController < ApplicationController

  def new
    @user = User.new(user_params)
  end

  def create
    @user = User.new
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

end
