class Task < ActiveRecord::Migration[5.1]
  def up
    rename_column :tasks, :expires_on, :expires_at
    change_column :tasks, :expires_at, :datetime, null: false
  end
  def down
    rename_column :tasks, :expires_at, :expires_on
    change_column :tasks, :expires_on, :date, null: true
  end
end
