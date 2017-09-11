class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :app_id
      t.string :customer_id
      t.string :account_no

      t.timestamps
    end
  end
end
