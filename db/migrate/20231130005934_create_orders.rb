class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.date :date_delivery
      t.references :collection, null: false, foreign_key: true
      t.string :customer

      t.timestamps
    end
  end
end
