require "csv"

module Versionamento
  module Headers
    class BooksController < ApplicationController
      def show
        @book = Book.find(params[:id])
        respond_to do |format|
          format.v1_json { render json: @book } # Versão completa
          format.v2_json { render json: @book.as_json(only: [ :title, :author ]) } # Versão "Light"
        end
      end
    end
  end
end
