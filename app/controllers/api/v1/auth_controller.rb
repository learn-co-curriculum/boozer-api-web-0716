class Api::V1::AuthController < ApplicationController
  before_action :authorize_user!, only: [:show]

  def create
    user = User.find_by(username: params[:username])
    if user.present? && user.authenticate(params[:password])
      render json: {
        id: user.id,
        username: user.username,
        jwt: JWT.encode(
          {user_id: user.id},
          ENV['JWT_SECRET'],
          ENV['JWT_ALGORITHM']
        )
      }
    else
      render json: {error: "couldn't find that user in our database"}, status: 404
    end
  end

  def show
    render json: {
      id: current_user.id,
      username: current_user.username
    }
  end
end
