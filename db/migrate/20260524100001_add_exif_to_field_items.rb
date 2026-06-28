class AddExifToFieldItems < ActiveRecord::Migration[8.1]
  def change
    add_column :field_items, :camera_make,   :string
    add_column :field_items, :camera_model,  :string
    add_column :field_items, :lens,          :string
    add_column :field_items, :focal_length,  :string
    add_column :field_items, :aperture,      :string
    add_column :field_items, :shutter_speed, :string
    add_column :field_items, :iso,           :integer
    add_column :field_items, :taken_at,      :datetime
    add_column :field_items, :gps_latitude,  :decimal, precision: 10, scale: 7
    add_column :field_items, :gps_longitude, :decimal, precision: 10, scale: 7
  end
end
