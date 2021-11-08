class CreateKnownSkills < ActiveRecord::Migration[6.1]
  def change
    create_table :known_skills do |t|
      t.uuid :user_id, null: false
      t.uuid :skill_id, null: false

      t.index [:user_id, :skill_id]
    end

    add_foreign_key :known_skills, :users
    add_foreign_key :known_skills, :skills
  end
end
