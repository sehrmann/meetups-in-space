class DropUidAndMid < ActiveRecord::Migration
  def change
    remove_column :meetups, :mid
    remove_column :users, :uid
  end
end
