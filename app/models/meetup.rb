class Meetup < ActiveRecord::Base
  has_many :rsvps
  has_many :users, through: :rsvps

  validates :meetup_name, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates :creator_id, numericality: true, presence: true
end
