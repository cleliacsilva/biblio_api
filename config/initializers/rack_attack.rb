class Rack::Attack
  # Configurar o cache para armazenar as contagens
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  throttle("limit_books_api", limit: 5, period: 1.minute) do |req|
    if req.path.include?("/seguranca/rate_limiting/books")
      req.ip # Identifica o "abusador" pelo endereço IP
    end
  end

  # Resposta Customizada (O que o usuário vê ao ser bloqueado)
  self.throttled_responder = lambda do |env|
    [ 429,  # Status Code: Too Many Requests
      { "Content-Type" => "application/json" },
      [ { error: "Calma! Limite de requisições excedido. Tente novamente em breve." }.to_json ]
    ]
  end
end
