# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  firstname       :string(255)
#  lastname        :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  attr_accessible :email, :firstname, :lastname, :password
  has_secure_password  
  has_and_belongs_to_many :projects 
  has_many :posts, dependent: :destroy
  has_many :conversations, :through => :posts 
  has_many :users, :through => :projects 
  has_many :initiatives, :class_name => 'Project', :foreign_key => "creator_id"

  has_many :votes
    
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
    
  validates :firstname, presence: true, length: { maximum: 50 }
  validates :lastname, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                       uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
    
end
