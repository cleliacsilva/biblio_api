class CreateApiKeys < ActiveRecord::Migration[8.1]
  def change
    create_table :api_keys do |t|
      t.string :name
      t.string :key
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :api_keys, :key, unique: true
  end
end
