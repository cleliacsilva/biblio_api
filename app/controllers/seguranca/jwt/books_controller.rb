module Seguranca
  module Jwt
    class BooksController < Seguranca::Jwt::ApplicationController
      def index
        @books = Book.all
        render json: @books, each_serializer: BookSerializer, status: :ok
      end
    end
  end
end
