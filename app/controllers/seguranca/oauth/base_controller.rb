module Seguranca
  module Oauth
    class ApplicationController < ActionController::API
      before_action :require_oauth_token

      private

      def require_oauth_token
        header = request.headers["Authorization"]
        token_string = header&.split(" ")&.last
        @user_token = UserToken.find_by(token: token_string)

        unless @user_token&.active?
          render json: { error: "Token OAuth inválido ou expirado" }, status: :unauthorized
        end
      end
    end
  end
end