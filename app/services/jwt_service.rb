class JwtService
  SECRET_KEY = ENV["JWT_SECRET_KEY"]

  def self.encode(payload, exp = 2.hours.from_now)
    exp_timestamp = exp.to_i
    payload[:exp] = exp_timestamp

    token = JWT.encode(payload, algorithm: 'HS256', SECRET_KEY)

    [token, exp_timestamp]
  end

  def self.decode(token)
    body = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new body
  rescue
    nil
  end
end
