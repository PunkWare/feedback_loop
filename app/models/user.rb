class User < ActiveRecord::Base
	attr_accessible :name, :email, :notified, :password, :password_confirmation
	has_secure_password
	has_many :surveys, dependent: :destroy
	has_many :answers, dependent: :destroy
	has_many :accesses, dependent: :destroy
	#has_many :questions, through: :answers
	before_save :create_remember_token
	before_save { |user| user.email = email.downcase }
	
	validates :name, presence: true, length: { maximum: 50 }
	
	VALID_EMAIL_REGEXP = /\A[a-z_\-][\w\-]*([(\.|+)][\w\-]+)*@[a-z_\-][\w\-]*(\.[\w\-]+)+\z/i
	# [a-z_\-]      : First character can't be a dot or a decimal
	# [\w\-]*       : Any word character (letter, number, underscore) and hyphen. any number of times
	# (\.[\w\-]+)*  : A dot or a plus sign, then any word character (letter, number, underscore) and hyphen at least one time (to ensure there's something after the dot). The whole any number of times
	# @             : A @ character
	# [a-z_\-]      : First character can't be a dot or a decimal
	# [\w\-]*       : Any word character (letter, number, underscore) and hyphen. any number of times
	# (\.[\w\-]+)+  : A dot, then any word character (letter, number, underscore) and hyphen at least one time (to ensure there's something after the dot). The whole at leastone time
	
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEXP}, uniqueness: { case_sensitive: false }
	
	validates :password, length: { minimum: 6 }
	validates :password_confirmation, presence: true
	
	private
	
		def create_remember_token
			begin
				self.remember_token = SecureRandom.urlsafe_base64
			end while User.exists?(self.remember_token)
		end
	
end
