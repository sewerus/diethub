class CreateTemplateDays < ActiveRecord::Migration[5.2]
  def change
    create_table :template_days do |t|
      t.belongs_to :patient
      t.string :title
      t.timestamps
    end
  end
end
