class ChangeIdToUuid < ActiveRecord::Migration[6.0]
  def up
    # Add the new uuid approach
    add_column :companies, :uuid, :uuid, null: false, default: -> { "gen_random_uuid()" }
    add_column :groups, :uuid, :uuid, null: false, default: -> { "gen_random_uuid()" }
    add_column :users, :uuid, :uuid, null: false, default: -> { "gen_random_uuid()" }

    # Remove the id column
    remove_column :companies, :id
    remove_column :groups, :id
    remove_column :users, :id

    # Rename the uuid to id
    rename_column :companies, :uuid, :id
    rename_column :groups, :uuid, :id
    rename_column :users, :uuid, :id

    # Add the primary key
    execute "ALTER TABLE companies ADD PRIMARY KEY (id);"
    execute "ALTER TABLE groups ADD PRIMARY KEY (id);"
    execute "ALTER TABLE users ADD PRIMARY KEY (id);"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
