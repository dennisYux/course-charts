class CreateProjects < ActiveRecord::Migration
  def change
    create_table(:projects) do |t|
    	t.string :name
    	t.string :description
    	t.string :manager

    	t.string :fmonth
    	t.string :fyear
    	t.string :tmonth
    	t.string :tyear    	

      t.timestamps
    end

    create_table(:users_projects, id: false) do |t|
    	t.references :user
    	t.references :project
    end

    add_index(:projects, :manager)
    add_index(:users_projects, [:user_id, :project_id])
  end
end
