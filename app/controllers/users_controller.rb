class UsersController < ApplicationController
	# arranges the signed_in_user method to be called before the given actions (edit and update)
	before_filter	:signed_in_user,	only: [:show, :edit, :update, :surveys] 
	before_filter	:new_user,			only: [:new, :create]
	before_filter	:correct_user,		only: [:show, :edit, :update]
	before_filter	:admin_user,		only: [:index, :destroy]	   
	
	def create
		@user = User.new(params[:user])
		if @user.save
			flash[ :success ] = "Welcome to Feedback Loop!"
			
			#redirect_to user_url(@user)
			
			# Immediately sign in the new user
			user = User.find_by_email(@user.email) 
			if user && user.authenticate(@user.password)
				sign_in user
			end
				
			redirect_to root_url
				
		else
			render 'new'
		end
	end
	
	def new
		@user = User.new
	end
	
	def show
		@user = User.find(params[:id])
		redirect_to(root_url, :alert => "Can't find user with id #{params[:id]}! Default to home page") if @user.nil?
	end

	def surveys
		@user = current_user
		redirect_to(root_url, :alert => "Can't find user with id #{params[:id]}! Default to home page") if @user.nil?

		@surveys = @user.surveys.paginate(page: params[:page])
	end
	
	def edit
		# @user = User.find(params[:id]) is no more required as it is called in
		# the 'correct_user' method below
	end
	
	def update
		# @user = User.find(params[:id]) is no more required as it is called in
		# the 'correct_user' method below
		
		if @user.update_attributes(params[:user])
			
			flash[:success] = "Profile updated."
			
			# the user is signed again as part of a successful profile update;
			# this is because the remember token gets reset when the user is saved
			# which invalidates the user’s session.
			# This is a nice security feature, as it means that any hijacked sessions
			# will automatically expire when the user information is changed
			sign_in @user
			
			redirect_to user_url(@user)
		else
			render 'edit'
		end
	end
	
	def index
		@users = User.paginate(page: params[:page])
	end
	
	def destroy
		deleted_user = User.find(params[:id])
		redirect_to(root_url, :alert => "Can't find user with id #{params[:id]}! Default to home page") if deleted_user.nil?

		deleted_user.destroy
		#deleted_user.destroy
		flash[:success] = "User " + deleted_user.name + " deleted."
		redirect_to users_url
	end
	
	private
			
			def new_user
				if signed_in?
					flash[:error] = "You already have an account."
					redirect_to(root_url)
				end
			end

			def correct_user
				@user = User.find(params[:id])
				redirect_to(root_url, :alert => "Access prohibited! Default to home page") unless current_user?(@user)
			end
			
			def admin_user
				redirect_to(root_url, :alert => "Access prohibited! Default to home page") unless (signed_in? && current_user.admin?)
			end
end
