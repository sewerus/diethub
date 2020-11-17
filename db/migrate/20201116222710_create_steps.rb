class CreateSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :steps do |t|
      t.belongs_to :recipe
      t.string :text
      t.integer :order_number
      t.timestamps
    end
  end
end
