class Survey < ActiveRecord::Base
	attr_accessible :title, :anonymous, :private, :available
	belongs_to :user
	has_many :questions, dependent: :destroy
	before_save :create_key

	validates :user_id,	presence: true
	validates :title,		presence: true

	default_scope order: 'surveys.created_at DESC'

	private

		def create_key
			self.key = SecureRandom.urlsafe_base64
		end
end
