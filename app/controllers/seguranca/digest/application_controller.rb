module Seguranca
  module Digest
    class ApplicationController < ActionController::API
      include ActionController::HttpAuthentication::Digest::ControllerMethods

      before_action :authorize_digest_request

      private

      def authorize_digest_request
        # O realm aqui tem que ser idêntico ao da Model
        authenticate_or_request_with_http_digest("BiblioAPI") do |email|
          user = User.find_by(email: email)
          user&.digest_password # Retorna o hash MD5 (não a senha!)
        end
      end
    end
  end
end
