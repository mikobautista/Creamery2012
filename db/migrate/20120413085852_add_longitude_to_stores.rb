class AddLongitudeToStores < ActiveRecord::Migration
  def change
    add_column :stores, :longitude, :float

  end
end
