class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string   :name
      t.integer  :tag
      t.datetime :due_at
      t.references :project

      t.timestamps
    end

    add_index :tasks, [:project_id, :tag]
  end
end
