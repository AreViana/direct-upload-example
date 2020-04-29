# frozen_string_literal: true

class Api::UsersController < ApplicationController
  def create
    response = CreateUser.call(user_params)
    render json: response
  end

  private
  def user_params
    params.require(:user).permit(:full_name, :email, :linkedin, :avatar)
  end
end
