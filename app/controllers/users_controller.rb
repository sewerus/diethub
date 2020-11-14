class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [
      :edit,
      :update,
      :show,
      :destroy,
      :reset_password
  ]
  before_action :set_current_user, only: [
      :edit_password,
      :update_password
  ]

  def index
    users = User.all
    filterrific_users(users)

    respond_to do |format|
      format.html
      format.js
    end
  rescue ActiveRecord::RecordNotFound => e
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
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

  def edit_password
  end

  def update_password
    if @user.update_with_password(password_params(current_user.class.to_s))
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in(@user)
      redirect_to root_path, notice: "Hasło zostało zmienione."
    else
      redirect_to edit_password_path, alert: "Nie udało się zmienić hasła!"
    end
  end

  def reset_password
    redirect_to user_path(@user), notice: @user.reset_password(current_user).to_s
  end

  protected

  def set_user
    @user = User.find_by(id: params[:id])
    if @user.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego użytkownika!"
    end
  end

  def set_current_user
    @user = current_user
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

  def password_params(user_class='other')
    if user_class == 'Admin'
      params.require(:admin).permit(:password, :password_confirmation, :current_password)
    elsif user_class == 'Dietician'
      params.require(:dietician).permit(:password, :password_confirmation, :current_password)
    elsif user_class == 'Patient'
      params.require(:patient).permit(:password, :password_confirmation, :current_password)
    else
      params.require(:user).permit(:password, :password_confirmation, :current_password)
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

  def filterrific_users(users, persistence = "users")
    @filterrific = initialize_filterrific(
        users,
        params[:filterrific],
        select_options: {
            sorted_by: User.options_for_sorted_by
        },
        default_filter_params: {},
        available_filters: [
                            :sorted_by,
                            :search_type,
                            :search_name,
                            :search_email,
                            :search_pesel,
                            :search_tel,
                            :search_street,
                            :search_city,
                            :search_post_code,
                            :created_at_gte,
                            :created_at_lt
        ],
        :persistence_id => persistence,
    ) or return

    @users = @filterrific.find.page(params[:page]).paginate(:page => params[:page], :per_page => 20)
  end
end
