class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:new, :set_messages_as_read]

  def index
    filterrific_users(current_user.messages_users)

    respond_to do |format|
      format.html
      format.js
    end
  rescue ActiveRecord::RecordNotFound => e
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

  def new
    @message = Message.new
    @message.addressee = @user
  end

  def create
    @message = Message.new(message_params)

    if @message.save
      respond_to do |format|
        format.js
      end
    else
      redirect_to messages_path, alert: 'Nie udało się utworzyć nowej wiadomości.'
    end
  end

  def set_messages_as_read
    Message.set_all_as_read(current_user, @user)
    respond_to do |format|
      format.js
    end
  end

  private

  def message_params
    result = params.require(:message).permit(:addressee_id, :content)
    result[:user_id] = current_user.id
    result
  end

  def filterrific_users(users, persistence = "messages_users")
    @filterrific = initialize_filterrific(
        users,
        params[:filterrific],
        select_options: {
            sorted_by: User.options_for_sorted_by
        },
        default_filter_params: {},
        available_filters: [
            :search_name,
        ],
        :persistence_id => persistence,
    ) or return

    @users = @filterrific.find.page(params[:page]).paginate(:page => params[:page], :per_page => 20)
  end

  def set_user
    @user = User.find_by(id: params[:id])
    if @user.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego użytkownika!"
    end
  end
end
