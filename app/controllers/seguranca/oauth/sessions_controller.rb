module Seguranca
  module Oauth
    class SessionsController < ActionController::API
      def callback
        # 1. Trocar o CODE pelo ACCESS_TOKEN do GitHub
        github_access_token = exchange_code_for_token(params[:code])

        # 2. Buscar os dados do usuário DIRETAMENTE no GitHub (Segurança!)
        user_data = fetch_github_user(github_access_token)

        # 3. Busca ou inicializa o usuário na SUA base
        user = User.find_or_initialize_by(uid: user_data[:id], provider: "github") do |u|
          u.email = user_data[:email]
          u.name = user_data[:name]
          u.password = SecureRandom.hex(16)
        end

        if user.save
          token = user.user_tokens.create!
          render json: { access_token: token.token, token_type: "Bearer" }, status: :ok
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: { error: "Falha na autenticação: #{e.message}" }, status: :unauthorized
      end

      def redirect_github
        client_id = ENV["GITHUB_CLIENT_ID"]
        # Escopo 'user:email' permite pegar o e-mail privado do usuário
        url = "https://github.com/login/oauth/authorize?client_id=#{client_id}&scope=user:email"

        # Como é uma API, você pode retornar a URL para o seu Front-end redirecionar
        # ou redirecionar diretamente se for uma chamada via navegador
        redirect_to url, allow_other_host: true
      end

      private

      def exchange_code_for_token(code)
        response = Faraday.post("https://github.com/login/oauth/access_token", {
          client_id: ENV["GITHUB_CLIENT_ID"],
          client_secret: ENV["GITHUB_CLIENT_SECRET"],
          code: code
        }, { "Accept" => "application/json" })

        JSON.parse(response.body)["access_token"]
      end

      def fetch_github_user(token)
        response = Faraday.get("https://api.github.com/user", nil, {
          "Authorization" => "Bearer #{token}"
        })
        data = JSON.parse(response.body)
        { id: data["id"], email: data["email"], name: data["name"] }
      end
    end
  end
end
