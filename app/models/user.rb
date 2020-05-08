class User < ApplicationRecord
  validates :email, uniqueness: true
  has_one_attached :avatar

  def avatar_url
    if avatar.attached?
      #avatar.service_url
      S3_BUCKET.object(avatar.key).public_url
    end
  end
end
