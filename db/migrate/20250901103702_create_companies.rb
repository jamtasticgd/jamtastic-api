class CreateCompanies < ActiveRecord::Migration[7.2]
  def change
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
  end
end
