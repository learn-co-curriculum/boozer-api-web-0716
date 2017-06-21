class ApplicationController < ActionController::API

  private

  def authorize_user!
    unless current_user.present?
      render json: {error: 'no user id present'}
    end
  end

  def current_user
    @current_user ||= User.find_by(id: user_id)
  end

  def user_id
    decoded_token.first['user_id']
  end

  def decoded_token
    if token
      begin
        JWT.decode(
          token,
          ENV['JWT_SECRET'],
          true,
          {algorithm: ENV['JWT_ALGORITHM']}
        )
      rescue JWT::DecodeError
        [{}]
      end
    else
      [{}]
    end
  end

  def token
    request.headers['Authorization']
  end

end
