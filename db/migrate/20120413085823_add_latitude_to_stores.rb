class AddLatitudeToStores < ActiveRecord::Migration
  def change
    add_column :stores, :latitude, :float

  end
end
