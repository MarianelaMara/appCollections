class AddIdIBonitaToCollections < ActiveRecord::Migration[7.0]
  def change
    add_column :collections, :id_i_bonita, :integer
  end
end
