class User < ApplicationRecord
  before_create :add_unsubscribe_hash
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :submissions, dependent: :destroy
  has_many :communities
  has_many :comments

  has_many :subscriptions
  has_many :communities, through: :subscriptions
  validates_uniqueness_of :username
  validates_presence_of :username

  has_many :subscribe_submissions, through: :communities,
                                   source: :submissions

  acts_as_voter

  private

  def add_unsubscribe_hash
    self.unsubscribed_hash = SecureRandom.hex
  end
end
