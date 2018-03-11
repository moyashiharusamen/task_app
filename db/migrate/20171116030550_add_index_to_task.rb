class AddIndexToTask < ActiveRecord::Migration[5.1]
  def change
    add_index :tasks, [:name, :status]
    add_index :tasks, :name
    add_index :tasks, :status
  end
end
