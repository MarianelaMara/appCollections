class AddQuantityToArticleMaterials < ActiveRecord::Migration[7.0]
  def change
    add_column :article_materials, :quantity, :integer
  end
end
