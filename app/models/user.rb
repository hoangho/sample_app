# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  has_many :microposts, dependent: :destroy

  before_save { |new_user| new_user.email.downcase! }
  before_save :create_remember_token

  # Validates
  validates :name, presence: true, length: {:maximum => 50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  					uniqueness: { case_sensitive: false}

  validates :password, length: {:minimum => 6 }
  validates :password_confirmation, presence: true

  # def initialize
  # 	self.name = "Unknown name"
  # 	self.email = "Unknown email"
  # 	self
  # end



  def self.search(search, page)
    paginate :per_page => 5, :page => page,
           :conditions => ['name like ?', "%#{search}%"],
           :order => 'name'
  end


  private 
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
      #If you are using Ruby 1.8.7, you should use SecureRandom.hex here instead
      # self.remember_token = SecureRandom.hex
    end
end
