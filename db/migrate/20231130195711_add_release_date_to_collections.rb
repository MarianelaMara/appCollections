class AddReleaseDateToCollections < ActiveRecord::Migration[7.0]
  def change
    add_column :collections, :release_date, :date
  end
end
