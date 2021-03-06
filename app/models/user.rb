class User < ApplicationRecord
  has_many :messages
  has_many :addressee_messages, class_name: "Message", foreign_key: "addressee_id"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def full_name
    self.name.to_s + " " + self.surname.to_s
  end

  def type_title
    if self.is_a? Admin
      "Admin"
    elsif self.is_a? Dietician
      "Dietetyk"
    elsif self.is_a? Patient
      "Pacjent"
    else
      "Inny"
    end
  end

  def self.save_new(params, current_user)
    user_data = params.require(:user).permit(:name, :surname, :email, :tel, :street, :city, :post_code, :pesel, :type)
    user_data[:password] = SecureRandom.hex
    user = User.create(user_data)
    user.password = SecureRandom.hex.to_s
    user.save!
    if current_user.is_a? Dietician
      user.dietician = current_user
    end
    user
  end

  def reset_password(current_user = nil)
    new_password = SecureRandom.hex[0..11].gsub("O", 'o').gsub("0", 'o').gsub("I", "L").gsub("l", "L")
    self.update_attribute(:password, new_password)
    "Nowe hasło użytkownika: " + new_password
  end

  def has_access_to_user?(user_id)
    if self.is_a? Admin
      true
    elsif self.is_a? Dietician
      user_id == self.id or user_id.in? self.patient_ids
    else
      false
    end
  end

  def messages_users
    if self.is_a? Admin
      User.all
    elsif self.is_a? Dietician
      User.where(id: (self.patients + Admin.all).pluck(:id))
    elsif self.is_a? Patient
      User.where(id: [self.dietician_id] + self.addressee_messages.pluck(:user_id))
    end
  end

  def can_show_user?(user_id)
    if self.is_a? Admin
      true
    elsif self.is_a? Dietician
      user_id == self.id or user_id.in? self.patient_ids
    else
      user_id == self.id
    end
  end

  def can_reset_password?(user_id)
    if self.is_a? Admin
      true
    elsif self.is_a? Dietician
      user_id.in? self.patient_ids
    else
      false
    end
  end

  filterrific(
      default_filter_params: {sorted_by: 'created_at_desc'},
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
      ]
  )
  scope :search_type, lambda { |query|
    return nil if query.blank?
    terms = query.mb_chars.downcase.split(/\s+/)
    terms = terms.map { |e| ''
    ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    num_or_conds = 1
    where(
        terms.map { |term|
          "(
            LOWER(users.type) LIKE ?
          )"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }
  scope :search_name, lambda { |query|
    return nil if query.blank?
    terms = query.mb_chars.downcase.split(/\s+/)
    terms = terms.map { |e| ''
    ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    num_or_conds = 2
    where(
        terms.map { |term|
          "(
            LOWER(users.name) LIKE ?
            OR
            LOWER(users.surname) LIKE ?
          )"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }
  scope :search_email, lambda { |query|
    return nil if query.blank?
    terms = query.to_s.mb_chars.downcase.split(/\s+/)
    terms = terms.map { |e| ''
    ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    num_or_conds = 1
    where(
        terms.map { |term|
          "(LOWER(users.email) LIKE ?)"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }
  scope :search_pesel, lambda { |query|
    return nil if query.blank?
    terms = query.to_s.mb_chars.downcase.split(/\s+/)
    terms = terms.map { |e| ''
    ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    num_or_conds = 1
    where(
        terms.map { |term|
          "(LOWER(users.pesel) LIKE ?)"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }
  scope :search_tel, lambda { |query|
    return nil if query.blank?
    terms = query.to_s.mb_chars.downcase.split(/\s+/)
    terms = terms.map { |e| ''
    ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    num_or_conds = 1
    where(
        terms.map { |term|
          "(LOWER(users.tel) LIKE ?)"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }
  scope :search_street, lambda { |query|
    return nil if query.blank?
    terms = query.to_s.mb_chars.downcase.split(/\s+/)
    terms = terms.map { |e| ''
    ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    num_or_conds = 1
    where(
        terms.map { |term|
          "(LOWER(users.street) LIKE ?)"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }
  scope :search_city, lambda { |query|
    return nil if query.blank?
    terms = query.to_s.mb_chars.downcase.split(/\s+/)
    terms = terms.map { |e| ''
    ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    num_or_conds = 1
    where(
        terms.map { |term|
          "(LOWER(users.city) LIKE ?)"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }
  scope :search_post_code, lambda { |query|
    return nil if query.blank?
    terms = query.to_s.mb_chars.downcase.split(/\s+/)
    terms = terms.map { |e| ''
    ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    num_or_conds = 1
    where(
        terms.map { |term|
          "(LOWER(users.post_code) LIKE ?)"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }
  scope :created_at_gte, lambda { |reference_time|
    if reference_time.length != 10
      return
    end
    where('users.created_at >= ?', reference_time)
  }
  scope :created_at_lt, lambda { |reference_time|
    if reference_time.length != 10
      return
    end
    where('users.created_at < ?', reference_time)
  }

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
      when /^created_at_/
        order("users.created_at #{ direction }")
      when /^name_/
        order(Arel.sql("LOWER(users.name) #{ direction }, LOWER(users.surname) #{ direction }"))
      when /^email_/
        order("LOWER(users.email) #{ direction }")
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.options_for_sorted_by
    [
        ['Imię (a-z)', 'name_asc'],
        ['Email (a-z)', 'email_asc'],
        ['Data zarejestrowania (od najnowszych)', 'created_at_desc'],
        ['Data zarejestrowania (od najstarszych)', 'created_at_asc']
    ]
  end
end
