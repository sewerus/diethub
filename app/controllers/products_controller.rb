class ProductsController < ApplicationController
  before_action :admin_and_dieticians_only
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
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

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to product_path(@product), notice: 'Produkt został zapisany.'
    else
      redirect_to products_path, alert: 'Nie udało się utworzyć nowego produktu.'
    end
  end

  def edit
  end

  def update
    if @product.update_attributes(product_params)
      redirect_to product_path(@product), notice: 'Produkt został zapisany.'
    else
      redirect_to product_path(@product), alert: 'Nie udało się zaktualizować produktu.'
    end
  end

  def destroy
    id = @product.id
    if @product.destroy
      redirect_to products_path, notice: 'Produkt został usunięty.'
    else
      redirect_to products_path, alert: 'Nie udało się usunąć produktu.'
    end
  end

  private
  def set_product
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      redirect_to root_path, alert: "Nie znaleziono szukanego produktu"
    end
  end

  def product_params
    params.require(:product).permit(:title, :description, :calories, :fat, :carbo, :protein, :author_id, :unit, :unit_amount)
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
