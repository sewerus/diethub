class PatientsController < UsersController
  before_action :admin_and_dieticians_only, only: [
      :new,
      :create
  ]

  def my_patients
    @title = "Lista moich pacjentów"
    filterrific_users(User.where(id: current_user.patient_ids))

    respond_to do |format|
      format.html
      format.js
    end
    if @filterrific
      render template: 'users/index'
    end
  rescue ActiveRecord::RecordNotFound => e
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

end
