class AddDetailsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :username, :string, :unique => true
  end

  def self.down
    remove_column :users, :username
    remove_column :users, :last_name
    remove_column :users, :first_name
  end
end
