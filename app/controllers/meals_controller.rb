class MealsController < ApplicationController
  before_action :admin_and_dieticians_only
  before_action :set_meal, only: [:show,
                                  :edit,
                                  :update,
                                  :edit_products,
                                  :update_products,
                                  :destroy,
                                  :add_product,
                                  :remove_product,
                                  :udpate_product_amount]
  before_action :set_product, only: [:add_product,
                                     :remove_product,
                                     :udpate_product_amount]

  def index
    meals = Meal.all
    filterrific_meals(meals)

    respond_to do |format|
      format.html
      format.js
    end
  rescue ActiveRecord::RecordNotFound => e
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

  def show
  end

  def new
    @meal = Meal.new
  end

  def create
    @meal = Meal.new(meal_params)

    if @meal.save
      redirect_to meal_path(@meal), notice: 'Posiłek został zapisany.'
    else
      redirect_to meals_path, alert: 'Nie udało się utworzyć nowego posiłku.'
    end
  end

  def edit
  end

  def update
    if @meal.update_attributes(meal_params)
      redirect_to edit_meal_products_path(@meal), notice: 'Posiłek został zapisany.'
    else
      redirect_to meal_path(@meal), alert: 'Nie udało się zaktualizować posiłku.'
    end
  end

  def edit_products
    products = Product.all
    filterrific_products(products)

    respond_to do |format|
      format.html
      format.js
    end
  rescue ActiveRecord::RecordNotFound => e
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

  def destroy
    id = @meal.id
    if @meal.destroy
      redirect_to meals_path, notice: 'Posiłek został usunięty.'
    else
      redirect_to meals_path, alert: 'Nie udało się usunąć posiłku.'
    end
  end

  def add_product
    @meal.add_product(params[:product_id])
    render "products/update_tr"
  end

  def remove_product
    @meal.remove_product(params[:product_id])
    render "products/update_tr"
  end

  def udpate_product_amount
    @meal.udpate_product_amount(params[:product_id], params[:meals_products_relationship])
    render "products/update_tr"
  end

  private
  def set_meal
    @meal = Meal.find_by(id: params[:id])
    if @meal.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego posiłku"
    end
  end
  
  def set_product
    @product = Product.find_by(id: params[:product_id])
    if @product.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego produktu"
    end
  end

  def meal_params
    params.require(:meal).permit(:title, :description, :author_id)
  end

  def filterrific_meals(meals, persistence = "meals")
    @filterrific = initialize_filterrific(
        meals,
        params[:filterrific],
        select_options: {
            sorted_by: Meal.options_for_sorted_by
        },
        default_filter_params: {},
        available_filters: [
            :sorted_by,
            :search_author,
            :search_title,
            :search_unit,
            :search_description,
            :search_calories_gte,
            :search_calories_lt,
            :search_fat_gte,
            :search_fat_lt,
            :search_carbo_gte,
            :search_carbo_lt,
            :search_protein_gte,
            :search_protein_lt
        ],
        :persistence_id => persistence,
    ) or return

    @meals = @filterrific.find.page(params[:page]).paginate(:page => params[:page], :per_page => 20)
  end

  def filterrific_products(products, persistence = "products")
    @filterrific = initialize_filterrific(
        products,
        params[:filterrific],
        select_options: {
            sorted_by: Product.options_for_sorted_by
        },
        default_filter_params: {},
        available_filters: [
            :sorted_by,
            :search_author,
            :search_title,
            :search_unit,
            :search_description,
            :search_calories_gte,
            :search_calories_lt,
            :search_fat_gte,
            :search_fat_lt,
            :search_carbo_gte,
            :search_carbo_lt,
            :search_protein_gte,
            :search_protein_lt
        ],
        :persistence_id => persistence,
    ) or return

    @products = @filterrific.find.page(params[:page]).paginate(:page => params[:page], :per_page => 20)
  end
end
