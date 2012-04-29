class Access < ActiveRecord::Base
	belongs_to :survey
	belongs_to :user

	validates :survey_id, presence: true
	validates :user_id, presence: true, uniqueness: { scope: :survey_id}
end
