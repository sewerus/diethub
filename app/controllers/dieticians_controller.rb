class DieticiansController < UsersController


  def show
    filterrific_patients(User.where(id: @user.patient_ids))

    respond_to do |format|
      format.html
      format.js {render "users/index"}
    end
  rescue ActiveRecord::RecordNotFound => e
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

  protected

  def filterrific_patients(users, persistence = "patients")
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
