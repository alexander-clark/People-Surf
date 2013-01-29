# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  email              :string(255)
#  type               :integer
#  active             :boolean
#  encrypted_password :string(255)
#  salt               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  admin              :boolean         default(FALSE)
#  first_name         :string(255)
#  last_name          :string(255)
#  username           :string(255)
#

require 'digest'
class User < ActiveRecord::Base
  #kludge. note to self: do not name columns 'type'
  User.inheritance_column = :classtype
  attr_accessor :password
  attr_accessible :email, :password, :password_confirmation, :first_name,
                  :last_name, :username, :subject_ids, :type
  attr_readonly :username, :type
  
  has_and_belongs_to_many :subjects
   
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
                    
  validates :type, :presence => true
  validates_inclusion_of :type, :in => 1..2
  
  validates :password, :presence     => true,
                       :confirmation => true, 
                       :length       => { :within => 6..40 }
  
  validates :username, :presence => true,
                       :uniqueness => { :case_sensitive => false }
                       
  validates :first_name, :presence => true 
                       
  validates :last_name, :presence => true 

  before_save :encrypt_password
  
  #Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  private
    
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
