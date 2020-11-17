class ContentInSteps < ActiveRecord::Migration[5.2]
  def change
    rename_column :steps, :text, :content
  end
end
