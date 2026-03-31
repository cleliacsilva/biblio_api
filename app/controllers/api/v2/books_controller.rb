module Api
  module V2
    class BooksController < ApplicationController
      def show
        @book = Book.find(params[:id])

        render json: @book.as_json(only: [ :title, :author ])
      end
    end
  end
end
