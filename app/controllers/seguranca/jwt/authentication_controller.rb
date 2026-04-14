module Seguranca
  module Jwt
    class AuthenticationController < Seguranca::Jwt::ApplicationController
      skip_before_action :authorize_request, raise: false

      def login
        @user = User.find_by(email: params[:email])

        if @user&.authenticate(params[:password])
          token, exp = JwtService.encode(user_id: @user.id)
          render json: { token: token, exp: exp, user: @user.name }, status: :ok
        else
          render json: { error: "Email ou senha inválidos" }, status: :unauthorized
        end
      end
    end
  end
end
