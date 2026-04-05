module Seguranca
  module Bearer
    class BooksController < Seguranca::Bearer::ApplicationController
      def index
        @books = Book.all
        render json: @books, each_serializer: BookSerializer, status: :ok
      end
    end
  end
end
