class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]

  def index
    @users = User.all
    ActiveRecord::Precounter.new(@users).precount(:tasks)
  end

  def show
    @tasks = @user.tasks.page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_user_path(@user), notice: "ユーザを作成しました"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "ユーザを修正しました"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email,
                                 :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
