class CreateSkills < ActiveRecord::Migration[7.2]
  def change
    create_table :skills do |t|
      t.string :code
      t.timestamps
    end

    add_index :skills, :code, unique: true
  end
end
