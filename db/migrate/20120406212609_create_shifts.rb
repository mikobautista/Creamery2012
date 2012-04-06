class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.integer :assignment_id
      t.date :date
      t.time :start_time
      t.time :end_time
      t.text :notes

      t.timestamps
    end
  end
end
