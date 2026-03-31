module Api
  module Nivel0
    class RpcController < ApplicationController
      # POST /api/nivel0/rpc/execute
      def execute
        # Tudo é POST, o que define a ação é o corpo da mensagem
        case params[:action_type]
        when "buscar_livro"
          render json: Book.find(params[:id])
        when "deletar_livro"
          Book.find(params[:id]).destroy
          render json: { message: "Apagado" }
        else
          render json: Book.all
        end
      end
    end
  end
end
