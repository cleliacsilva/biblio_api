module Api
  module MediaTypes
    class ApplicationController < ActionController::Base
      include ActionController::MimeResponds

      before_action :ensure_json_or_xml_request
      before_action :parse_xml_params

      private

      def ensure_json_or_xml_request
        return if request.get? || request.delete?

        allowed_types = [
          "application/json",
          "application/xml",
          "application/vnd.biblioapi.v1+json",
          "application/vnd.biblioapi.v2+json"
        ]

        unless allowed_types.include?(request.content_type)
          render json: { error: "Unsupported Media Type" }, status: :unsupported_media_type
        end
      end

      def parse_xml_params
        if request.content_type == "application/xml" && request.body.present?
          begin
            xml_data = Hash.from_xml(request.body.read)
            params.merge!(xml_data) if xml_data.present?
          rescue StandardError => e
            render xml: { error: "XML Malformatado: #{e.message}" }.to_xml, status: :bad_request
          end
        end
      end
    end
  end
end
