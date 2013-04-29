class AddCompletedToTasks < ActiveRecord::Migration
  def up
  	add_column :tasks, :completed, :boolean, :default => false
  end
 
  def down
    remove_column :completed
  end
end
