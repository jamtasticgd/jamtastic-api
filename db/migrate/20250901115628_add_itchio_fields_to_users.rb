class AddItchioFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :itchio_id, :string
    add_column :users, :itchio_username, :string
    add_column :users, :itchio_access_token, :text
    
    add_index :users, :itchio_id, unique: true
    add_index :users, :itchio_username
  end
end
