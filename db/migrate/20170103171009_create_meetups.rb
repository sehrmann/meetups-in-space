class CreateMeetups < ActiveRecord::Migration
  def change
    create_table :meetups do |table|
      table.string :mid, null: false
      table.string :creator, null: false
      table.string :meetup_name, null: false
      table.string :description, null: false
      table.string :location, null: false

      table.timestamps null: false
    end

  end
end
