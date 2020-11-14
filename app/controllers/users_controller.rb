class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [
      :edit,
      :update,
      :show,
      :destroy
  ]

  def index
    @users = User.all
  end

  def edit

  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    end
  end

  def show

  end

  def destroy

  end

  def new
    @user = User.new
  end

  def save_new
    @user = User.save_new(params)
    redirect_to user_path(@user)
  end

  protected

  def set_user
    @user = User.find_by(id: params[:id])
    if @user.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego użytkownika!"
    end
  end

  def user_params
    if @user.is_a? Admin
      params.require(:admin).permit(:name, :surname, :email, :tel, :street, :city, :post_code, :pesel)
    elsif @user.is_a? Dietician
      params.require(:dietician).permit(:name, :surname, :email, :tel, :street, :city, :post_code, :pesel)
    elsif @user.is_a? Patient
      params.require(:patient).permit(:name, :surname, :email, :tel, :street, :city, :post_code, :pesel)
    end
  end

  def user_path(user)
    if user.is_a? Admin
      return admin_path(user)
    elsif user.is_a? Dietician
      return dietician_path(user)
    elsif user.is_a? Patient
      return patient_path(user)
    end
  end
end
