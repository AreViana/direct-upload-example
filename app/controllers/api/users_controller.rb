# frozen_string_literal: true

class Api::UsersController < ApplicationController
  def create
    response = CreateUser.call(user_params)
    render json: response
  end

  def show
    user = User.find(params[:id])
    render json: user.to_json
  end

  private
  def user_params
    params.require(:user).permit(:full_name, :email, :linkedin, :avatar)
  end
end
