class AddPresupuestoToArticleMaterials < ActiveRecord::Migration[7.0]
  def change
    add_column :article_materials, :presupuesto, :decimal
  end
end
