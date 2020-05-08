# frozen_string_literal: true

class CreateUser < BaseService
  def initialize(params)
    validate_params(params.to_h)
    @user_params = params.except(:avatar)
    @avatar = params[:avatar]
  end

  def call
    user = User.create!(user_params)
    user.avatar.attach(avatar) if avatar.present? && !!user

    user.as_json(root: false, methods: :avatar_url).except('updated_at')
  end

  private

  attr_reader :user_params, :avatar

  def validate_params(params)
    validation = UserContract.new.call(params)
    raise CustomError.new(
      details: validation.errors.to_hash,
      title: 'Unprocessable entity',
      message: 'Validation failed',
      status: 422
    ) if validation.failure?
  end
end
