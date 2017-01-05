class Rsvp < ActiveRecord::Base
  belongs_to :meetup
  belongs_to :user

  validates :meetup_id, presence: true
  validates :user_id, presence: true
end
