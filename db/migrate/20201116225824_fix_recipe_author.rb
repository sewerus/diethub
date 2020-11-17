class FixRecipeAuthor < ActiveRecord::Migration[5.2]
  def change
    rename_column :recipes, :author_id_id, :author_id
  end
end
