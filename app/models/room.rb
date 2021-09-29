class Room < ApplicationRecord
  has_many :chats
  has_many :user_rooms #１つのルームにいるユーザー数は2人になるためhas_manyになる
end
