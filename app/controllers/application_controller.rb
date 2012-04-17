class ApplicationController < ActionController::Base
	protect_from_forgery
	include SurveysHelper
	include SessionsHelper
	include QuestionsHelper
end
