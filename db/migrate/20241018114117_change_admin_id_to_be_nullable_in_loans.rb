class ChangeAdminIdToBeNullableInLoans < ActiveRecord::Migration[7.1]
  def change
    change_column :loans, :admin_id, :integer, null: true
  end
end
