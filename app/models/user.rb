class User < ApplicationRecord
  has_secure_password

  has_many :user_tokens, dependent: :destroy

  before_save :set_digest_password


  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true

  private

  def set_digest_password
    # O "realm" deve ser exatamente o mesmo usado no controller
    realm = "BiblioAPI"
    self.digest_password = Digest::MD5.hexdigest("#{email}:#{realm}:#{password}")
  end
end
