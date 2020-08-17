class AddApiKeyToUsers < ActiveRecord::Migration[5.2]
  def change
    # TODO: Given more time, I would make this column encrypted
    add_column :users, :api_key, :string
  end
end
