class PopulateSkills < ActiveRecord::Migration[6.0]
  BASIC_SKILLS = ['art', 'audio', 'code', 'game_design', 'writing']

  def up
    BASIC_SKILLS.each do |skill|
      Skill.find_or_create_by(
        code: skill
      )
    end
  end

  def down
    Skill.where(code: BASIC_SKILLS).delete_all
  end
end
