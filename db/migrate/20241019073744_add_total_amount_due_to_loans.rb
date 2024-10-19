class AddTotalAmountDueToLoans < ActiveRecord::Migration[7.1]
  def change
    add_column :loans, :total_amount_due, :decimal
  end
end
