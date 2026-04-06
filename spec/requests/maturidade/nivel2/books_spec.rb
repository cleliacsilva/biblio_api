# spec/requests/maturidade/nivel2/books_spec.rb
require 'swagger_helper'

RSpec.describe 'Maturidade Nível 2', type: :request do
  path '/maturidade/nivel2/books' do
    get 'Lista livros' do
      tags 'Maturidade - Nível 2'
      produces 'application/json'

      response '200', 'sucesso' do
        run_test!
      end
    end
  end
end
