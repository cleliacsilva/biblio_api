module Seguranca
  module Basic
    class BooksController < Seguranca::Basic::ApplicationController
      def index
        @books = Book.all
        render json: @books, each_serializer: BookSerializer, status: :ok
      end
    end
  end
end
