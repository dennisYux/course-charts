class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
			# t.string 	 :user_name
			t.text	 	 :description
			t.decimal  :hours, precision: 4, scale: 2
			# t.datetime :created_at

			t.references :user
			t.references :task

      t.timestamps
    end

    add_index :records, [:user_id, :task_id]
  end
end
