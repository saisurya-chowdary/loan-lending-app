class Wallet < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :admin_user, class_name: 'AdminUser', optional: true, foreign_key: :admin_user_id
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def credit(amount)
    self.balance += amount
    save!
  end

  def debit(amount)
    self.balance -= amount
    save!
  end
end
