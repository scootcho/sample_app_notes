class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end

  def following?(other_user)    #other_user is just a place holder for the parameter, it can be anything.
    relationships.find_by(followed_id: other_user.id)    #check if this relationship exist by finding passed in user.id in the "followed_id" column
  end

  def follow!(other_user)       #other_user is just a place holder for the parameter, it can be anything.
    relationships.create!(followed_id: other_user.id)   #this method will create a row in the relationships table with @user(follower_id/foreign key) and other_user(followed_id)
  end

  def unfollow!(other_user)      #other_user is just a place holder for the parameter, it can be anything.
    relationships.find_by(followed_id: other_user.id).destroy   #find the user.id in relationships table and destroy it
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)  #creates a hashed remember_token in the db. Not in cookies.
    end
end