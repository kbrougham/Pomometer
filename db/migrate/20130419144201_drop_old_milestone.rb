class DropOldMilestone < ActiveRecord::Migration
  def up
  end

  def down
  	remove_column :tasks, :milestone_id_id
  end

end
