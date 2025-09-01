class CreateBasicTables < ActiveRecord::Migration[7.0]
  def change
    # Create users table
    create_table :users do |t|
      t.string :email, default: "", null: false
      t.string :encrypted_password, default: "", null: false
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email
      t.string :name
      t.string :telegram
      t.text :tokens
      t.string :provider, default: "email", null: false
      t.string :uid, default: "", null: false
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, [:uid, :provider], unique: true

    # Create companies table
    create_table :companies do |t|
      t.string :name
      t.string :email
      t.string :facebook
      t.string :twitter
      t.string :url
      t.string :logo
      t.timestamps
    end

    add_index :companies, :name, unique: true

    # Create groups table
    create_table :groups do |t|
      t.string :name
      t.integer :member_count
      t.timestamps
    end

    # Create skills table
    create_table :skills do |t|
      t.string :code
      t.timestamps
    end

    add_index :skills, :code, unique: true

    # Create teams table
    create_table :teams do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.boolean :approve_new_members, null: false
      t.timestamps
    end

    add_index :teams, :created_at

    # Create team_members table
    create_table :team_members do |t|
      t.references :team, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :approved, null: false
      t.string :kind, null: false
      t.timestamps
    end

    add_index :team_members, [:team_id, :user_id], unique: true

    # Create needed_skills table
    create_table :needed_skills do |t|
      t.references :team, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
    end

    add_index :needed_skills, [:team_id, :skill_id]

    # Create known_skills table
    create_table :known_skills do |t|
      t.references :user, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
    end

    add_index :known_skills, [:user_id, :skill_id]
  end
end