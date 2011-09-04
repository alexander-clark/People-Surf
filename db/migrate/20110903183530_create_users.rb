class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.integer :type
      t.boolean :active
      t.string :encrypted_password
      t.string :salt

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
