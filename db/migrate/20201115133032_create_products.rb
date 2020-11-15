class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :title
      t.integer :calories
      t.integer :fat
      t.integer :carbo
      t.integer :protein
      t.text :description
      t.belongs_to :author
      t.timestamps
    end
  end
end
