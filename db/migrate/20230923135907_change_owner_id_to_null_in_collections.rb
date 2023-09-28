class ChangeOwnerIdToNullInCollections < ActiveRecord::Migration[7.0]
  def change
    change_column :collections, :owner_id, :bigint, null: true
  end
end
