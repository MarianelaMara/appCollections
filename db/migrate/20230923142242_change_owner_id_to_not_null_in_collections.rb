class ChangeOwnerIdToNotNullInCollections < ActiveRecord::Migration[7.0]
  def change
    change_column :collections, :owner_id, :bigint, null: false
  end
end
