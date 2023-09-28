class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :model
      t.references :category, null: false, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
