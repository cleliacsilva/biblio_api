module Api
  module V1
    class BooksController < ApplicationController
      before_action :set_book, only: %i[ show update destroy ]

      # GET /books
      def index
        @books = Book.all

        respond_to do |format|
          format.json { render json: @books }
          format.xml  { render xml: @books.map(&:attributes).to_xml(root: "books") }
          format.csv  { send_data @books.to_csv, filename: "biblioteca-#{Date.today}.csv" }
        end
      end

      # GET /books/1
      def show
        @book = Book.find(params[:id])

        respond_to do |format|
          format.json { render json: @book }
          format.xml  { render xml: @book.attributes.to_xml(root: "book") }
        end
      end

      # POST /books
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

      # PATCH/PUT /books/1
      def update
        if @book.update(book_params)
          render json: @book
        else
          render json: @book.errors, status: :unprocessable_content
        end
      end

      # DELETE /books/1
      def destroy
        @book.destroy!
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_book
          @book = Book.find(params.expect(:id))
        end

        # Only allow a list of trusted parameters through.
        def book_params
          params.require(:book).permit(:title, :author, :isbn, :available)
        end
    end
  end
end
