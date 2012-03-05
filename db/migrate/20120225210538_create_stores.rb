class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :state, :default => "PA"
      t.string :zip
      t.string :phone
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
