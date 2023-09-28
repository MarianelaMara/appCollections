class CreateCollections < ActiveRecord::Migration[7.0]
  def change
    create_table :collections do |t|
      t.string :name
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.integer :manufacturing_lead_time
      t.date :estimated_release_date

      t.timestamps
    end
  end
end
