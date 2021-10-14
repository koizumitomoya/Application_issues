class Book < ApplicationRecord 
	belongs_to :user
	validates :title, presence: true
	validates :body ,presence: true, length: {maximum: 200}
  is_impressionable counter_cache: true
  
  has_many :favorites
  has_many :book_comments
  has_many :favorite_users, through: :favorites, source: :user

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } #今日
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } #前日
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day )} #今週
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day)}#先週

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
