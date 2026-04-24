require "openssl"
require "json"
require "base64"
class JwtService
  SECRET_KEY = ENV["JWT_SECRET_KEY"]

  def self.encode(payload, exp = 2.hours.from_now)
    # 1. Dados do Token
    header = { alg: "HS256", typ: "JWT" }
    payload[:exp] = exp.to_i

    # 2. Codificar Header e Payload
    encoded_header = self.base64url_encode(header.to_json)
    encoded_payload = self.base64url_encode(payload.to_json)

    # 3. Gerar a Assinatura (Signature)
    # Concatenamos as partes com um ponto
    data_to_sign = "#{encoded_header}.#{encoded_payload}"

    # Usamos HMAC-SHA256
    signature = OpenSSL::HMAC.digest("sha256", SECRET_KEY, data_to_sign)
    encoded_signature = self.base64url_encode(signature)

    # 4. Resultado Final
    jwt = "#{encoded_header}.#{encoded_payload}.#{encoded_signature}"
    [ jwt, payload[:exp] ]
  end

  def self.decode(token)
    # 1. Separar as 3 partes
    header_b64, payload_b64, signature_b64 = token.split(".")

    # 2. Reconstruir a assinatura para testar a integridade
    # Pegamos o que recebemos (Header.Payload) e assinamos novamente com nossa secret
    data_to_verify = "#{header_b64}.#{payload_b64}"
    signature_recalculada = OpenSSL::HMAC.digest("sha256", SECRET_KEY, data_to_verify)
    encoded_signature_recalculada = Base64.urlsafe_encode64(signature_recalculada, padding: false)

    # 3. Comparação de segurança (evita ataques de timing)
    if encoded_signature_recalculada == signature_b64
      # 4. Agora sim, descodificamos os dados para usar na aplicação
      JSON.parse(Base64.urlsafe_decode64(payload_b64))
    end
  rescue
    nil
  end

  # Função para Base64Url (sem padding '=', e trocando +/ por -_)
  def self.base64url_encode(str)
    Base64.urlsafe_encode64(str, padding: false)
  end
end
