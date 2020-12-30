class Message < ApplicationRecord
  belongs_to :user
  belongs_to :addressee, class_name: "User"

  scope :unread, -> {
    where(read: false)
  }

  def self.set_all_as_read(reading, writing)
    Message.where(addressee: reading).where(user: writing).update_all(read: true)
  end

  def self.talk(user_a, user_b)
    Message.where(addressee: [user_a, user_b]).where(user: [user_a, user_b])
  end
end
