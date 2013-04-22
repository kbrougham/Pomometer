class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.string :name
      t.datetime :starts_at
      t.datetime :ends_at

      t.references :project
      t.timestamps
    end
  end
end
