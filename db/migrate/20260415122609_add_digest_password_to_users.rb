class AddDigestPasswordToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :digest_password, :string
  end
end
