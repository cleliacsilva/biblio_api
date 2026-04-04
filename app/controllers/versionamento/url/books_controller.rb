module Versionamento
  module Url
    class BooksController < ApplicationController
      def show
        @book = Book.find(params[:id])
        if params[:v] == "1"
          render json: @book
        else
          render json: @book.as_json(only: [ :title, :author ])
        end
      end
    end
  end
end
