class AddTokenInfoToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
    add_column :users, :telegram, :string
    add_column :users, :tokens, :json
    add_column :users, :provider, :string, null: false, default: 'email'
    add_column :users, :uid, :string, null: false, default: ''

    add_index :users, [:uid, :provider], unique: true
  end
end
