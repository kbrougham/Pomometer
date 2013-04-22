class AddMilestoneToTasks < ActiveRecord::Migration
  def change
  	change_table :tasks do |t|
  		t.references :milestone
  	end
  end
end
