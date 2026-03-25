module Api
  module V1
    class BooksController < ApplicationController
      before_action :set_book, only: %i[ show update destroy ]

      def index
        @books = Book.all

        respond_to do |format|
          format.json { render json: @books } # application/json
          format.xml  { render xml: @books.map(&:attributes).to_xml(root: "books") } # application/xml
          format.csv  { send_data @books.to_csv, filename: "biblioteca-#{Date.today}.csv" } # text/csv
        end
      end

      def show
        @book = Book.find(params[:id])

        respond_to do |format|
          format.json { render json: @book } # application/json
          format.xml  { render xml: @book.attributes.to_xml(root: "book") } # application/xml
        end
      end

      def create
        @book = Book.new(book_params)

        if @book.save
          respond_to do |format|
            format.json { render json: @book, status: :created }
            format.xml  { render xml: @book.to_xml, status: :created }
          end
        else
          respond_to do |format|
            format.json { render json: @book.errors, status: :unprocessable_entity }
            format.xml  { render xml: @book.errors.to_xml, status: :unprocessable_entity }
          end
        end
      end

      def update
        if @book.update(book_params)
          render json: @book
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
