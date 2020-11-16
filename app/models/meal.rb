class Meal < ApplicationRecord
  belongs_to :author, class_name: "User"
  #products
  has_many :products_relationships, class_name: "MealsProductsRelationship",
           foreign_key: "meal_id",
           dependent: :destroy
  has_many :products, through: :products_relationships, source: :product


  def can_be_edited?(user)
    user.is_a? Admin or user.id == self.author_id
  end
  
  def update_numbers
    calories = 0
    fat = 0
    carbo = 0
    protein = 0
    self.products_relationships.each do |product_rel|
      amount = product_rel.units_amount
      product = product_rel.product
      unit_amount = product.unit_amount
      calories += amount * product.calories / unit_amount
      fat += amount * product.fat / unit_amount
      carbo += amount * product.carbo / unit_amount
      protein += amount * product.protein / unit_amount
    end
    self.calories = carbo
    self.fat = fat
    self.carbo = carbo
    self.protein = protein
    self.save
  end

  def consists?(product)
    !MealsProductsRelationship.where(product_id: product.id).where(meal_id: self.id).empty?
  end

  def add_product(product_id)
    mp = MealsProductsRelationship.new
    mp.meal = self
    mp.product_id = product_id
    mp.save!
  end

  def remove_product(product_id)
    MealsProductsRelationship.where(meal_id: self.id).where(product_id: product_id).destroy_all
  end

  def udpate_product_amount(product_id, amount_params)
    unless amount_params.nil?
      amount = amount_params[:units_amount]
      mp = MealsProductsRelationship.where(meal_id: self.id).where(product_id: product_id).first
      unless mp.nil?
        mp.update(units_amount: amount)
      end
    end
  end

  def product_relationship(product)
    MealsProductsRelationship.where(meal_id: self.id).where(product_id: product.id).first
  end

  filterrific(
      default_filter_params: {sorted_by: 'title_asc'},
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
      ]
  )
  scope :search_author, lambda { |query|
    return nil if query.blank?
    terms = query.mb_chars.downcase.split(/\s+/)
    terms = terms.map { |e| ''
    ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    num_or_conds = 2
    where(
        terms.map { |term|
          "(
              EXISTS (
                SELECT id FROM users WHERE
                id = meals.author_id
                AND
                (
                  LOWER(users.name) LIKE ?
                  OR
                  LOWER(users.surname) LIKE ?
                )
              )
          )"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }
  scope :search_title, lambda { |query|
    return nil if query.blank?
    terms = query.to_s.mb_chars.downcase.split(/\s+/)
    terms = terms.map { |e| ''
    ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    num_or_conds = 1
    where(
        terms.map { |term|
          "(LOWER(meals.title) LIKE ?)"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }
  scope :search_unit, lambda { |query|
    return nil if query.blank?
    terms = query.to_s.mb_chars.downcase.split(/\s+/)
    terms = terms.map { |e| ''
    ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    num_or_conds = 1
    where(
        terms.map { |term|
          "(LOWER(meals.unit) LIKE ?)"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }
  scope :search_description, lambda { |query|
    return nil if query.blank?
    terms = query.to_s.mb_chars.downcase.split(/\s+/)
    terms = terms.map { |e| ''
    ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    num_or_conds = 1
    where(
        terms.map { |term|
          "(LOWER(meals.description) LIKE ?)"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }
  scope :search_calories_gte, lambda { |amount|
    amount = amount.to_i
    where('meals.calories >= ?', amount)
  }
  scope :search_calories_lt, lambda { |amount|
    amount = amount.to_i
    where('meals.calories < ?', amount)
  }
  scope :search_fat_gte, lambda { |amount|
    amount = amount.to_i
    where('meals.fat >= ?', amount)
  }
  scope :search_fat_lt, lambda { |amount|
    amount = amount.to_i
    where('meals.fat < ?', amount)
  }
  scope :search_carbo_gte, lambda { |amount|
    amount = amount.to_i
    where('meals.carbo >= ?', amount)
  }
  scope :search_carbo_lt, lambda { |amount|
    amount = amount.to_i
    where('meals.carbo < ?', amount)
  }
  scope :search_protein_gte, lambda { |amount|
    amount = amount.to_i
    where('meals.protein >= ?', amount)
  }
  scope :search_protein_lt, lambda { |amount|
    amount = amount.to_i
    where('meals.protein < ?', amount)
  }

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
      when /^title_/
        order("LOWER(meals.title) #{ direction }")
      when /^calories_/
        order("LOWER(meals.calories) #{ direction }")
      when /^fat_/
        order("LOWER(meals.fat) #{ direction }")
      when /^carbo_/
        order("LOWER(meals.carbo) #{ direction }")
      when /^protein_/
        order("LOWER(meals.protein) #{ direction }")
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.options_for_sorted_by
    [
        ['Tytuł (a-z)', 'title_asc'],
        ['Kalorie (rosnąco)', 'calories_asc'],
        ['Kalorie (malejąco)', 'calories_desc'],
        ['Tłuszcze (rosnąco)', 'fat_asc'],
        ['Tłuszcze (malejąco)', 'fat_desc'],
        ['Węglowodany (rosnąco)', 'carbo_asc'],
        ['Węglowodany (malejąco)', 'carbo_desc'],
        ['Białko (rosnąco)', 'protein_asc'],
        ['Białko (malejąco)', 'protein_desc']
    ]
  end
end
