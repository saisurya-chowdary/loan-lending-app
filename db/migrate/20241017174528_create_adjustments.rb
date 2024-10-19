class CreateAdjustments < ActiveRecord::Migration[7.1]
  def change
    create_table :adjustments do |t|
      t.references :loan, null: false, foreign_key: true
      t.decimal :amount
      t.decimal :interest_rate

      t.timestamps
    end
  end
end
