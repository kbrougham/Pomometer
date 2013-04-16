class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string :goal
      t.text :notes
      t.datetime :started_at
      t.integer :duration
      t.datetime :ended_at
      t.references :task

      t.timestamps
    end
  end
end
