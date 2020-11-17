class Product < ApplicationRecord
  belongs_to :author, class_name: "User"
  #meal
  has_many :meals_relationships, class_name:  "MealsProductsRelationship",
          foreign_key: "product_id", dependent:   :destroy
  has_many :meals, through: :meals_relationships, source: :meal

  validates :calories, format: {with: /\A\d+\z/,
                                message: "Tu powinna być tylko liczba!"}
  validates :fat, format: {with: /\A\d+\z/,
                                message: "Tu powinna być tylko liczba!"}
  validates :carbo, format: {with: /\A\d+\z/,
                                message: "Tu powinna być tylko liczba!"}
  validates :protein, format: {with: /\A\d+\z/,
                                message: "Tu powinna być tylko liczba!"}
  validates :unit_amount, format: {with: /\A\d+\z/,
                                message: "Tu powinna być tylko liczba!"}

  after_update :update_all_meals

  def creates?(meal)
    !MealsProductsRelationship.where(product_id: self.id).where(meal_id: meal.id).empty?
  end

  def can_be_edited?(user)
    user.is_a? Admin or user.id == self.author_id
  end

  def amount_text(number, with_number = false)
    if with_number
      result = number.to_s + " "
      if number == number.to_i
        result = number.to_i.to_s + " "
      end
    else
      result = ""
    end
    if number.to_i == number and number.to_i == 1
      result += self.unit_s
    elsif number.to_i != number or (number.to_i % 10 < 5 and (number < 10))
      result += self.unit_pl
    else
      result += self.unit_pl_2
    end
    result
  end

  def unit_s
    self.unit.split("/").first || ""
  end

  def unit_pl
    self.unit.split("/").second || ""
  end

  def unit_pl_2
    self.unit.split("/").third || ""
  end

  def amount_g(number)
    result = self.unit_amount * number
    if result == result.to_i
      result = result.to_i
    end
    result
  end

  def update_all_meals
    self.meals.each do |meal|
      meal.update_numbers
    end
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
                id = products.author_id
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
          "(LOWER(products.title) LIKE ?)"
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
          "(LOWER(products.unit) LIKE ?)"
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
          "(LOWER(products.description) LIKE ?)"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }
  scope :search_calories_gte, lambda { |amount|
    amount = amount.to_i
    where('products.calories >= ?', amount)
  }
  scope :search_calories_lt, lambda { |amount|
    amount = amount.to_i
    where('products.calories < ?', amount)
  }
  scope :search_fat_gte, lambda { |amount|
    amount = amount.to_i
    where('products.fat >= ?', amount)
  }
  scope :search_fat_lt, lambda { |amount|
    amount = amount.to_i
    where('products.fat < ?', amount)
  }
  scope :search_carbo_gte, lambda { |amount|
    amount = amount.to_i
    where('products.carbo >= ?', amount)
  }
  scope :search_carbo_lt, lambda { |amount|
    amount = amount.to_i
    where('products.carbo < ?', amount)
  }
  scope :search_protein_gte, lambda { |amount|
    amount = amount.to_i
    where('products.protein >= ?', amount)
  }
  scope :search_protein_lt, lambda { |amount|
    amount = amount.to_i
    where('products.protein < ?', amount)
  }

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
      when /^title_/
        order("LOWER(products.title) #{ direction }")
      when /^calories_/
        order("LOWER(products.calories) #{ direction }")
      when /^fat_/
        order("LOWER(products.fat) #{ direction }")
      when /^carbo_/
        order("LOWER(products.carbo) #{ direction }")
      when /^protein_/
        order("LOWER(products.protein) #{ direction }")
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
