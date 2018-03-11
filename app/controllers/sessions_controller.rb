class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user&.authenticate(params[:session][:password])
      login user
      redirect_to root_path
    else
      flash.now.alert = "メールアドレスかパスワードが間違っています"
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to login_path, notice: "ログアウトしました"
  end

  private

  def login(user)
    session[:user_id] = user.id
  end

  def logout
    reset_session
    @current_user = nil
  end

end
