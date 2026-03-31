Rails.application.routes.draw do
  namespace :api do
    # Nível 0: O Pântano do POX
    # Não usamos verbos HTTP nem múltiplas URIs. Existe apenas um "ponto de entrada" (endpoint) que recebe tudo via POST.
    namespace :nivel0 do
      post "biblioteca_rpc", to: "rpc#execute"
    end

    # Nível 1: Recursos (URIs Individuais)
    # Dividimos o endpoint único em várias URIs, mas ainda usamos os verbos de forma errada (ex: tudo é GET ou tudo é POST).
    namespace :nivel1 do
      get "books/get_all", to: "books#get_all"
      get "books/get_one/:id", to: "books#get_one"
      get "books/create_new", to: "books#create_new" # Erro semântico: GET para criar
    end

    # Nível 2: Verbos HTTP + Status Codes
    # Usa GET para ler, POST para criar, DELETE para apagar e retorna 201 Created ou 404 Not Found.
    namespace :nivel2 do
      resources :books
    end

    # Nível 3: HATEOAS
    # Além de usar verbos HTTP, cada resposta inclui links para as ações relacionadas
    namespace :nivel3 do
      resources :books
    end

    #  É o contrato que garante que o cliente e o servidor falem a mesma língua.
    namespace :media_types do
      resources :books
    end
  end
end
