class CreateDays < ActiveRecord::Migration[5.2]
  def change
    create_table :days do |t|
      t.string :title
      t.belongs_to :patient
      t.date :date
      t.belongs_to :template_day
      t.integer :sleep_time
      t.timestamps
    end
  end
end
