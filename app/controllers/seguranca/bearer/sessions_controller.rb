module Seguranca
  module Bearer
    class SessionsController < ActionController::API
      def create
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          # Cria um novo "bit" de acesso no banco
          user_token = user.user_tokens.create!
          render json: { token: user_token.token, type: "Bearer" }
        else
          render json: { error: "Incorreto" }, status: :unauthorized
        end
      end
    end
  end
end
