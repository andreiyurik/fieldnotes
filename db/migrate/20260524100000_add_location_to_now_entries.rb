class AddLocationToNowEntries < ActiveRecord::Migration[8.1]
  def change
    add_column :now_entries, :location, :string
  end
end
