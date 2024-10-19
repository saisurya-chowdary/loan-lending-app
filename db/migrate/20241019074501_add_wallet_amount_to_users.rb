class AddWalletAmountToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :wallet_amount, :decimal
  end
end
