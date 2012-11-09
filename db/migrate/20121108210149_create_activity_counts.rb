class CreateActivityCounts < ActiveRecord::Migration
  def change
    create_table :activity_counts do |t|
      t.integer :count
      t.integer :userid
      t.integer :time

      t.timestamps
    end
  end
end
