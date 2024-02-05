class User < ApplicationRecord
  validates :email, presence: true

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[email encrypted_password]
  end
end
