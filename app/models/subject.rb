# == Schema Information
#
# Table name: subjects
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  ancestry    :string(255)
#

class Subject < ActiveRecord::Base
  attr_accessible :name, :description, :parent_id
  
  has_ancestry
  
  has_and_belongs_to_many :users
  
  validates :name, :presence => true,
                   :uniqueness => { :case_sensitive => false }
end
