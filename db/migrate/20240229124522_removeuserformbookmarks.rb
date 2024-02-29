class Removeuserformbookmarks < ActiveRecord::Migration[7.1]
  def change
    remove_column :bookmarks, :user_id
  end
end
