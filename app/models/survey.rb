class Survey < ActiveRecord::Base
	attr_accessible :title, :anonymous, :private, :available, :link
	belongs_to :user
	has_many :questions, dependent: :destroy
	has_many :accesses, dependent: :destroy
	before_create :create_key
	before_save :well_formed_uri

	validates :user_id,	presence: true
	validates :title,		presence: true

	default_scope order: 'surveys.created_at DESC'

	private

		def create_key
			self.key = SecureRandom.urlsafe_base64
		end

		def well_formed_uri
			self.link = ("http://" << self.link) if ! self.link.nil? and self.link.start_with?('www') 
		end
end
