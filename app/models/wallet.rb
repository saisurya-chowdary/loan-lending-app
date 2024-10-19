class Wallet < ApplicationRecord
  belongs_to :user

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
