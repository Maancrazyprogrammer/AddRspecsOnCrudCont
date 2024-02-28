class Removetokenfromusers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :token
  end
end
