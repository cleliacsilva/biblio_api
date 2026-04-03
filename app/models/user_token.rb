class UserToken < ApplicationRecord
  belongs_to :user
  before_create :generate_token

  def active?
    expires_at > Time.current
  end

  private

  def generate_token
    self.token = SecureRandom.hex(32)
    self.expires_at ||= 1.minute.from_now
  end
end
