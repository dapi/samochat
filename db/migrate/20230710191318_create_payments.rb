class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :account, null: false
      t.references :payment_card
      t.string :token, null: false
      t.decimal :amount, precision: 9, scale: 2, null: false
      t.jsonb :dump, null: false

      t.timestamps
    end
  end
end
