require 'swagger_helper'

RSpec.describe 'Biblio API - Documentação Completa', type: :request do
  # Helper para criar um livro padrão nos testes que precisam de ID
  let!(:book) { Book.create(title: 'Dom Casmurro', author: 'Machado de Assis', isbn: '123456') }
  let(:id) { book.id }

  ##########################################
  ######## MATURIDADE DE RICHARDSON ########
  ##########################################

  # Nível 0: RPC
  path '/maturidade/nivel0/biblioteca_rpc' do
    post 'Nível 0: RPC (Pântano do POX)' do
      tags 'Maturidade de Richardson'
      consumes 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          command: { type: :string, example: 'get_book' },
          id: { type: :integer, example: 1 }
        }
      }
      response '200', 'Comando executado (Mesmo em erro, retorna 200)' do
        let(:body) { { command: 'get_book', id: 1 } }
        run_test!
      end
    end
  end

  # Nível 1: Recursos
  path '/maturidade/nivel1/books/get_all' do
    get 'Nível 1: Listar Todos' do
      tags 'Maturidade de Richardson'
      response '200', 'Livros encontrados' do
        run_test!
      end
    end
  end

  # Nível 2: Verbos HTTP
  path '/maturidade/nivel2/books' do
    get 'Nível 2: Listar (GET)' do
      tags 'Maturidade de Richardson'
      response '200', 'Sucesso' do
        run_test!
      end
    end

    post 'Nível 2: Criar (POST)' do
      tags 'Maturidade de Richardson'
      consumes 'application/json'
      parameter name: :book_params, in: :body, schema: {
        type: :object,
        properties: { title: { type: :string }, author: { type: :string } }
      }
      response '201', 'Criado' do
        let(:book_params) { { title: 'Novo Livro', author: 'Autor' } }
        run_test!
      end
    end
  end

  ##########################################
  ############### MEDIA TYPES ##############
  ##########################################

  # --- TESTE DO INDEX (Formatos Padrão) ---
  path '/media_type/books' do
    get 'Listar Livros com Media Types Diferentes' do
      tags 'Media Types'
      # No index, seu controller aceita JSON e XML
      produces 'application/json', 'application/xml'

      response '200', 'Retorno em JSON padrão' do
        let(:Accept) { 'application/json' }
        run_test!
      end

      response '200', 'Retorno em XML' do
        let(:Accept) { 'application/xml' }
        run_test!
      end
    end
  end

  # --- TESTE DO SHOW (Formatos Customizados / Versionados) ---
  path '/media_type/books/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Exibir Livro com Vendor Types' do
      tags 'Media Types'
      produces 'application/vnd.biblioapi.v1+json', 'application/vnd.biblioapi.v2+json'

      let(:id) { Book.create!(title: 'Teste', author: 'Autor').id }

      response '200', 'Versão 1 do Contrato' do
        let(:Accept) { 'application/vnd.biblioapi.v1+json' }
        run_test!
      end

      response '200', 'Versão 2 do Contrato (Reduzido)' do
        let(:Accept) { 'application/vnd.biblioapi.v2+json' }
        run_test!
      end
    end
  end

  ##########################################
  ############# VERSIONAMENTOS #############
  ##########################################

  path '/versionamento/url/books/{id}' do
    parameter name: :id, in: :path, type: :string
    get 'Versionamento por URL' do
      tags 'Versionamento'
      response '200', 'v1 ou v2 via URL' do
        run_test!
      end
    end
  end

  ##########################################
  ############# SEGURANÇA #############
  ##########################################

  # API KEY
  path '/seguranca/api_key/books' do
    get 'Segurança: API Key' do
      tags 'Segurança'
      parameter name: 'X-Api-Key', in: :header, type: :string

      # Cria uma chave no banco para o teste passar
      let(:'X-Api-Key') do
        api_key = ApiKey.create!(name: 'Parceiro Teste', key: SecureRandom.hex, active: true)
        api_key.key
      end

      response '200', 'Acesso autorizado via Header' do
        run_test!
      end
    end
  end

  # BASIC AUTH
  path '/seguranca/basic/books' do
    get 'Segurança: Basic Auth' do
      tags 'Segurança'
      security [ basic_auth: [] ]

      let!(:user) { User.create!(name: 'Admin', email: 'admin@teste.com', password: 'password123') }

      let(:Authorization) do
        auth_string = "admin@teste.com:password123"
        "Basic #{Base64.strict_encode64(auth_string)}"
      end

      response '200', 'Usuário autenticado com sucesso' do
        run_test!
      end

      response '401', 'Acesso negado - Credenciais inválidas' do
        let(:Authorization) { "Basic #{Base64.strict_encode64('errado:errado')}" }
        run_test!
      end
    end
  end

  # BEARER TOKEN (Banco de Dados)
  # BEARER TOKEN (Banco de Dados)
  path '/seguranca/bearer/books' do
    get 'Segurança: Bearer Token' do
      tags 'Segurança'
      security [ bearer_auth: [] ]

      let(:user) { User.create!(name: 'User', email: "user#{rand(999)}@t.com", password: '123') }
      let(:Authorization) do
        # REMOVIDO o 'active: true' que estava causando o erro
        token_record = user.user_tokens.create!
        "Bearer #{token_record.token}"
      end

      response '200', 'Token válido no banco' do
        run_test!
      end
    end
  end

  # JWT
  path '/seguranca/jwt/books' do
    get 'Segurança: JWT' do
      tags 'Segurança'
      security [ bearer_auth: [] ]

      let(:user) { User.create!(name: 'User JWT', email: "jwt#{rand(999)}@t.com", password: '123') }
      let(:Authorization) do
        token = JwtService.encode(user_id: user.id)
        "Bearer #{token}"
      end

      response '200', 'JWT decodificado com sucesso' do
        run_test!
      end
    end
  end

  ##########################################
  ############# CACHE #############
  ##########################################

  path '/cache/books' do
    get 'Listagem com Cache' do
      tags 'Cache'
      response '200', 'Retorno com ETag/Last-Modified' do
        run_test!
      end
    end
  end
end
