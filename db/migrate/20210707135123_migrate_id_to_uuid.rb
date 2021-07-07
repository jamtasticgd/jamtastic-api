class MigrateIdToUuid < ActiveRecord::Migration[6.1]
  def up
    # Add the new uuid approach
    add_column :needed_skills, :uuid, :uuid, null: false, default: -> { "gen_random_uuid()" }
    add_column :team_members, :uuid, :uuid, null: false, default: -> { "gen_random_uuid()" }

    # Remove the id column
    remove_column :needed_skills, :id
    remove_column :team_members, :id

    # Rename the uuid to id
    rename_column :needed_skills, :uuid, :id
    rename_column :team_members, :uuid, :id

    # Add the primary key
    execute "ALTER TABLE needed_skills ADD PRIMARY KEY (id);"
    execute "ALTER TABLE team_members ADD PRIMARY KEY (id);"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
