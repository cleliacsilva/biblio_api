module Api
  module Nivel1
    class BooksController < ApplicationController
      # GET /api/nivel1/books/get_all
      def get_all
        @books = Book.all
        render json: { 
          mensagem: "Lista de todos os livros (Nível 1: URI específica)",
          dados: @books 
        }
      end

      # GET /api/nivel1/books/get_one/:id
      def get_one
        @book = Book.find(params[:id])
        render json: @book, serializer: nil
      rescue ActiveRecord::RecordNotFound
        render json: { erro: "Livro não encontrado" }, status: 404
      end

      # GET /api/nivel1/books/create_new?title=...&author=...
      # No Nível 1, é comum ver criações via GET passando parâmetros na URL
      def create_new
        @book = Book.new(
          title: params[:title],
          author: params[:author],
          isbn: params[:isbn],
          available: true
        )

        if @book.save
          render json: { 
            status: "Sucesso", 
            mensagem: "Livro criado via URI de ação específica",
            livro: @book 
          }
        else
          render json: { erro: "Falha ao criar" }, status: 400
        end
      end
    end
  end
end