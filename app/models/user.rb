# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
  # if attr not accessible we cannot  direct init value for it
  attr_accessible :email, :name, :password, :password_confirmation
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_secure_password

  validates :name, presence: true , length: { maximum: 50 }
  # Comment for REGEX
  # / match start of regex
  # \A match start of string
  # \z match end of string
  # i case insensitive
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true , format: { with: VALID_EMAIL_REGEX } , uniqueness: { case_sensitive: false }
  validates :password_confirmation , presence: true
  validates :password , presence: true, length: { minimum: 6 }
  before_save { self.email = self.email.downcase }
  before_save :create_remember_token

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end

  # Ham kiem tra xem mot user da follow nguoi khac thanh cong chua
   def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  private 
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
