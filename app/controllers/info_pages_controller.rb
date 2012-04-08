class InfoPagesController < ApplicationController
	def home
		@surveys = Survey.where(:closed => false, :private => false).order("created_at DESC").paginate(page: params[:page]) if signed_in?
		#@surveys = @surveys.paginate(page: params[:page])
	end

	def help
	end

	def about
	end
end
