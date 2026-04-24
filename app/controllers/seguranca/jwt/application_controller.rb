module Seguranca
  module Jwt
    class ApplicationController < ActionController::Base
      before_action :authorize_request

      def authorize_request
        header = request.headers["Authorization"]
        header = header.split(" ").last if header
        begin
          @decoded = JwtService.decode(header)
          @current_user = User.find(@decoded["user_id"]) if @decoded
        rescue ActiveRecord::RecordNotFound => e
          render json: { errors: e.message }, status: :unauthorized
        rescue JWT::DecodeError => e
          render json: { errors: e.message }, status: :unauthorized
        end

        render json: { error: "Não autorizado" }, status: :unauthorized unless @current_user
      end
    end
  end
end
