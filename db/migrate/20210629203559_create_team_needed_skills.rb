class CreateTeamNeededSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :needed_skills do |t|
      t.uuid :team_id, null: false
      t.uuid :skill_id, null: false

      t.index [:team_id, :skill_id]
    end

    add_foreign_key :needed_skills, :teams
    add_foreign_key :needed_skills, :skills
  end
end
