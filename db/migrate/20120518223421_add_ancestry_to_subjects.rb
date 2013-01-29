class AddAncestryToSubjects < ActiveRecord::Migration
  def self.up
    add_column :subjects, :ancestry, :string
    add_index :subjects, :ancestry
  end

  def self.down
    remove_index :subjects, :ancestry
    remove_column :subjects, :ancestry
  end
end
