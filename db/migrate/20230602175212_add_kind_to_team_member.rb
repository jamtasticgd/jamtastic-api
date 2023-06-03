class AddKindToTeamMember < ActiveRecord::Migration[7.0]
  def change
    add_column :team_members, :kind, :string, null: false
  end
end
