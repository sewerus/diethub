class CreateTemplateDayParts < ActiveRecord::Migration[5.2]
  def change
    create_table :template_day_parts do |t|
      t.string :title
      t.belongs_to :template_day
      t.integer :hour
      t.integer :minute
      t.integer :time_margin
      t.text :description
      t.timestamps
    end
  end
end
