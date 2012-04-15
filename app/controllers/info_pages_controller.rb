class InfoPagesController < ApplicationController
	def home
		@surveys = Survey.where(:available => true, :private => false).order("created_at DESC").paginate(page: params[:page]) if signed_in?
	end

	def help
	end

	def about
	end
end
