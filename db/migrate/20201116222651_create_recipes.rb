class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.belongs_to :meal
      t.belongs_to :author_id
      t.timestamps
    end
  end
end
