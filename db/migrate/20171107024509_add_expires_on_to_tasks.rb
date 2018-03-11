class AddExpiresOnToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :expires_on, :date
  end
end
