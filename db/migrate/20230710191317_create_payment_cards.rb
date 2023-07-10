class CreatePaymentCards < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_cards do |t|
      t.references :account, null: false
      t.string :token, null: false
      t.string :card_first_six, null: false
      t.string :card_last_four, null: false
      t.string :card_type, null: false
      t.string :issuer_bank_country, null: false
      t.string :card_exp_date, null: false
      t.jsonb :dump, null: false

      t.timestamps
    end
  end
end
