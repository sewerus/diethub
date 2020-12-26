class FixMinutesInDayParts < ActiveRecord::Migration[5.2]
  def change
    rename_column :day_parts, :minutes, :minute
  end
end
