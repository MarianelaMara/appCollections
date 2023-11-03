class AddBudgetToCollections < ActiveRecord::Migration[7.0]
  def change
    add_column :collections, :budget, :decimal
  end
end
