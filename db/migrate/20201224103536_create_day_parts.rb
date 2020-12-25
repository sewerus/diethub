class CreateDayParts < ActiveRecord::Migration[5.2]
  def change
    create_table :day_parts do |t|
      t.string :title
      t.belongs_to :day
      t.integer :hour
      t.integer :minutes
      t.integer :time_margin
      t.text :description
      t.timestamps
    end
  end
end
