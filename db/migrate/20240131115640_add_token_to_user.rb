class AddTokenToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :token, :string, :limit => 1000
  end
end
