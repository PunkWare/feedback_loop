class InfoPagesController < ApplicationController
	def home
		if signed_in?
			non_private_surveys	= Survey.where(available: true, private: false)
			private_surveys 		= Survey.joins(:accesses).where(available: true)

			merged_surveys = non_private_surveys.concat(private_surveys)
			merged_surveys.sort! {|x,y| y.created_at <=> x.created_at }
			@surveys = merged_surveys.paginate(page: 1, per_page: 30)
		end
	end

	def help
	end

	def contact
	end
end
