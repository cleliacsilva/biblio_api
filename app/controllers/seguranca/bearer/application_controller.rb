module Seguranca
  module Bearer
    class ApplicationController < ActionController::API
      before_action :authorize_bearer_token

      attr_reader :current_user

      private

      def authorize_bearer_token
        # Busca o Header "Authorization: Bearer <token>"
        header = request.headers["Authorization"]
        token_string = header&.split(" ")&.last

        # Procura o token no banco de dados
        user_token = UserToken.find_by(token: token_string)

        if user_token&.active?
          @current_user = user_token.user
        else
          render json: { error: "Token inválido ou expirado" }, status: :unauthorized
        end
      end
    end
  end
end