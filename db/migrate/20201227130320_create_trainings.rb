class CreateTrainings < ActiveRecord::Migration[5.2]
  def change
    create_table :trainings do |t|
      t.belongs_to :day
      t.integer :hour
      t.integer :minute
      t.integer :time_length
      t.text :description
      t.timestamps
    end
  end
end
