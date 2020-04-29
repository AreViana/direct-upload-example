class User < ApplicationRecord
  validates :name, :email, presence: true
  has_one_attached :avatar
end
