module Api
  module Nivel3
    class BooksController < ApplicationController
      before_action :set_book, only: %i[ show update destroy ]

      def index
        @books = Book.all

        render json: @books, status: :ok
      end

      def show
        @book = Book.find(params[:id])
        if @book
          render json: @book, serializer: BookSerializer, status: :ok
        else
          render json: { error: "Book not found" }, status: :not_found
        end
      end

      def create
        @book = Book.new(book_params)

        if @book.save
          render json: @book, serializer: BookSerializer, status: :created
        else
          render json: @book.errors, status: :unprocessable_entity
        end
      end

      def update
        if @book.update(book_params)
          render json: @book, serializer: BookSerializer, status: :ok
        else
          render json: @book.errors, status: :unprocessable_content
        end
      end

      def destroy
        @book.destroy!
      end

      private
        def set_book
          @book = Book.find(params.expect(:id))
        end

        def book_params
          params.require(:book).permit(:title, :author, :isbn, :available)
        end
    end
  end
end
