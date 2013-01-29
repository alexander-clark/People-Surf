class CreateSubjectUserJoinTable < ActiveRecord::Migration
  def self.up
    create_table :subjects_users, :id => false do |t|
      t.integer :subject_id
      t.integer :user_id
    end 
  end

  def self.down
    drop_table:subjects_users
  end
end
