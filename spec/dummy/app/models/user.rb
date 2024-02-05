class User < ApplicationRecord
  validates :email, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %i[email encrypted_password]
  end
end
