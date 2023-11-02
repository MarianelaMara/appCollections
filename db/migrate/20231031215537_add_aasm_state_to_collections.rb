class AddAasmStateToCollections < ActiveRecord::Migration[7.0]
  def change
    add_column :collections, :aasm_state, :string
  end
end
