class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :description
      t.float  :hours
      t.references :user
      t.references :task

      t.timestamps
    end

    add_index :records, [:user_id, :task_id]
  end
end
