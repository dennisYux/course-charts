class CreateProjects < ActiveRecord::Migration
  def change
    create_table(:projects) do |t|
      t.string :name
      t.string :description
      t.string :manager
      t.datetime :due_at

      t.timestamps
    end

    add_index(:projects, :manager)
  end
end
