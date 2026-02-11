class CreateNeededSkills < ActiveRecord::Migration[7.2]
  def change
    create_table :needed_skills do |t|
      t.references :team, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
    end

    add_index :needed_skills, [:team_id, :skill_id]
  end
end
