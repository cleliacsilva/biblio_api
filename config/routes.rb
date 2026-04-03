Rails.application.routes.draw do
  ##########################################
  ######## MATURIDADE DE RICHARDSON ########
  ##########################################
  namespace :maturidade do
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
  end

  ##########################################
  ############### MEDIA TYPES ##############
  ##########################################
  namespace :media_type do
    resources :books
  end

  ##########################################
  ############# VERSIONAMENTOS #############
  ##########################################
  namespace :versionamento do
    namespace :headers do
      resources :books, only: :show
    end

    namespace :url do
      resources :books, only: :show
    end

    namespace :v1 do
      resources :books, only: :show
    end

    namespace :v2 do
      resources :books, only: :show
    end
  end

  ##########################################
  ############# CACHES #############
  ##########################################
  namespace :cache do
    resources :books, only: [:index, :show]
    get "books/:id/permanent_info", to: "books#permanent_info"
  end

  ##########################################
  ############# SEGURANÇA #############
  ##########################################
  namespace :seguranca do
    namespace :basic do
      resources :books, only: :index
    end

    namespace :jwt do
      post "auth/login", to: "authentication#login"
      resources :books, only: :index
    end

    namespace :api_key do
      resources :books, only: :index
    end
  end
end
