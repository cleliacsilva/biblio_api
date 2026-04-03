module Seguranca
  module Oauth
    class SessionsController < ActionController::API
      def callback
        # 1. Busca ou inicializa o usuário
        user = User.find_or_initialize_by(uid: params[:uid], provider: params[:provider]) do |u|
          u.email = params[:email]
          u.name = params[:name]
          u.password = SecureRandom.hex(16)
        end

        # 2. SALVA o usuário primeiro (O Bit de Ouro!)
        if user.save
          # 3. Agora que ele tem um ID, podemos criar o token
          token = user.user_tokens.create!
          render json: { 
            access_token: token.token,
            token_type: "Bearer"
          }, status: :ok
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end