class CreateTeams < ActiveRecord::Migration[7.2]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.boolean :approve_new_members, null: false
      t.timestamps
    end

    add_index :teams, :created_at
  end
end
