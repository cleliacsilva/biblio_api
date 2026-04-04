module Seguranca
  module Basic
    class ApplicationController < ActionController::API
      include ActionController::HttpAuthentication::Basic::ControllerMethods

      before_action :authorize_basic_request

      private

      def authorize_basic_request
        authenticate_or_request_with_http_basic("BiblioAPI") do |email, password|
          user = User.find_by(email: email)
          user && user.authenticate(password)
        end
      end
    end
  end
end

