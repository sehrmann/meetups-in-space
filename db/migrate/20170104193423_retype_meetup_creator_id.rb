class RetypeMeetupCreatorId < ActiveRecord::Migration
  def change
    change_column :meetups, :creator, 'integer USING CAST(creator AS integer)'
    rename_column :meetups, :creator, :creator_id
  end
end
