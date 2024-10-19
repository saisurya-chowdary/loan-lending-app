class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :loans
  has_one :wallet

  def self.ransackable_attributes(auth_object = nil)
    ["id", "email", "admin", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["loans"]
  end

  def admin?
    self.admin == true
  end
end
