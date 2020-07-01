class CreateSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :skills, id: :uuid  do |t|
      t.string :code

      t.timestamps
    end

    add_index :skills, :code, unique: true
  end
end
