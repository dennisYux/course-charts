class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
			# t.string 	 :user_name
			t.string :description
			t.float  :hours
			# t.datetime :created_at

			t.references :user
			t.references :task

      t.timestamps
    end

    add_index :records, [:user_id, :task_id]
  end
end
