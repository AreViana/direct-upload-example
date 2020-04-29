class User < ApplicationRecord
  validates :full_name, :email, presence: true
  validates_length_of :avatar, is: 122, if: -> { avatar.present? }
  has_one_attached :avatar

  def avatar_url
    if avatar.attached?
      avatar.service_url
      # S3_BUCKET.object(avatar.key).public_url
    end
  end
end
