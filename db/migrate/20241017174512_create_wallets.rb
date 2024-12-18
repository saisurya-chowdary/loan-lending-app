class CreateWallets < ActiveRecord::Migration[7.1]
  def change
    create_table :wallets do |t|
      t.decimal :balance
      t.references :user, foreign_key: true
      t.references :admin_user, foreign_key: true

      t.timestamps
    end
  end
end
