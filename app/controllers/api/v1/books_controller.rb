module Api
  module V1
    class BooksController < ApplicationController
      def show
        @book = Book.find(params[:id])

        render json: @book
      end
    end
  end
end
