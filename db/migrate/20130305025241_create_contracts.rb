class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.references :user
      t.references :project

      t.timestamps
    end

    add_index(:contracts, [:user_id, :project_id])
  end
end
