class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.decimal :amount, null: false, default: 0
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
