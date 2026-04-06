module Seguranca
  module ApiKey
    class ApplicationController < ActionController::API
      before_action :authorize_api_key

      private

      def authorize_api_key
        # Buscamos a chave no Header customizado 'X-Api-Key'
        key = request.headers["X-Api-Key"]
        @api_client = ::ApiKey.find_by(key: key, active: true)

        unless @api_client
          render json: { error: "API Key inválida ou inativa" }, status: :unauthorized
        end
      end
    end
  end
end
