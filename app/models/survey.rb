class Survey < ActiveRecord::Base
	attr_accessible :title
	belongs_to :user
	before_save :create_key_token

	validates :user_id, presence: true
	validates :title,  presence: true

	default_scope order: 'surveys.title'

	private
  
    def create_key_token
      self.key = SecureRandom.urlsafe_base64
    end
end
