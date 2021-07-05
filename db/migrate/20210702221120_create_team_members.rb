class CreateTeamMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :team_members do |t|
      t.uuid :team_id, null: false
      t.uuid :user_id, null: false
      t.boolean :approved, null: false

      t.timestamps
    end

    add_foreign_key :team_members, :teams
    add_foreign_key :team_members, :users

    add_index :team_members, [:team_id, :user_id], unique: true
  end
end
