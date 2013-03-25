class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string     :invitation_token
      t.datetime   :invitation_sent_at
      t.string     :invitation_accepted, default: "no"
      t.string     :email
      t.references :project

      t.timestamps
    end
  end
end
