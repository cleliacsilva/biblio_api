module Seguranca
  module ApiKey
    class BooksController < Seguranca::ApiKey::ApplicationController
      def index
        @books = Book.all
        puts "Acesso feito pelo parceiro: #{@api_client.name}"
        render json: @books
      end
    end
  end
end