module Seguranca
  module Digest
    class BooksController < Seguranca::Digest::ApplicationController
      def index
        @books = Book.all
        render json: @books, status: :ok
      end
    end
  end
end
