class ApiKey < ApplicationRecord
  validates :name, presence: true
  validates :key, uniqueness: true

  # Gera uma chave aleatória e segura antes de criar no banco
  before_create :generate_key

  private

  def generate_key
    self.key = SecureRandom.hex(24) if key.blank?
  end
end
