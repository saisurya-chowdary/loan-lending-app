class CreateLoans < ActiveRecord::Migration[7.1]
  def change
    create_table :loans do |t|
      t.decimal :amount
      t.decimal :interest_rate
      t.integer :state
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
