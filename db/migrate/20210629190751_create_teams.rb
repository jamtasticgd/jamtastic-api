class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams, id: :uuid do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.boolean :approve_new_members, null: false
      t.uuid :user_id, null: false

      t.timestamps
      t.index :created_at
    end

    add_foreign_key :teams, :users
  end
end
