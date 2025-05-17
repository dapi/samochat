class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.references :account, null: false, foreign_key: true
      t.decimal :amount, precision: 9, scale: 2, null: false
      t.timestamp :fully_paid_at

      t.timestamps
    end
  end
end
