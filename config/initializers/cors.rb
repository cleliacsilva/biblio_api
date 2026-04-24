Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Em vez de "*", coloque a URL exata do seu frontend
    origins [
      "https://www.google.com", # Exemplo de origem permitida
      "http://localhost:3000",
      "https://805f-187-87-130-145.ngrok-free.app" # Substitua pelo URL do seu frontend
    ]

    resource "*",
      headers: :any,
      methods: [ :get, :post, :patch, :put, :delete, :options, :head ],
      expose: [ "Access-Control-Allow-Origin" ]
  end
end
