class CreateKnownSkills < ActiveRecord::Migration[7.2]
  def change
    create_table :known_skills do |t|
      t.references :user, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
    end

    add_index :known_skills, [:user_id, :skill_id]
  end
end
