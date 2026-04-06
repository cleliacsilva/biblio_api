module Seguranca
  module RateLimiting
    class BooksController < ApplicationController
      def index
        @books = Book.all
        render json: {
          message: "Esta é a rota com limite de 5 req/min",
          books: @books
        }
      end
    end
  end
end
