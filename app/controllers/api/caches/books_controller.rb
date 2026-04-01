module Api
  module Caches
    class BooksController < ApplicationController
      def index
        # Tenta buscar no cache, se não existir, busca no banco e salva por 12 horas
        @books = Rails.cache.fetch("active_books_list", expires_in: 12.hours) do
          Book.where(available: true).to_a
        end

        render json: @books
      end

      def show
        # curl -I -H 'If-None-Match: W/"2cdcdc4b8f58c0c19ba224c14e59edcb"' http://localhost:3000/api/caches/books/1
        @book = Book.find(params[:id])
        # DIRETIVAS DE VISIBILIDADE E VALIDADE:
        # public: permite que CDNs e Proxies armazenem o dado.
        # must_revalidate: obriga o cliente a reconfirmar após a expiração.
        expires_in 1.hour, public: true, must_revalidate: true
        # VALIDAÇÃO CONDICIONAL (HATEOAS de Cache):
        # O Rails compara o If-None-Match (ETag) enviado pelo cliente.
        # Se for igual, responde 304 Not Modified e nem executa a renderização do JSON.
        render json: @book if stale?(@book) # If-None-Match
      end

      # Exemplo de Recurso Imutável (Capas ou PDFs fixos)
      def permanent_info
        @book = Book.find(params[:id])
        # Informa que este dado NUNCA mudará. O navegador nem pergunta ao servidor novamente.
        # cache-control = max-age=3155695200, public, immutable
        http_cache_forever(public: true) do
          render json: { info: "Dados históricos e imutáveis do livro" }
        end
      end
    end
  end
end
