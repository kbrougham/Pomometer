class SessionsController < ApplicationController
	
	def new
	end

	def create
		admin = Admin.find_by_username(params[:username])
		if admin.password = params[:password]
			session[:admin_id] = admin.id
			redirect_to root_url, notice: "Logged In!"
		else
			flash.now.alert = "Invalid username or password"
			render "new"
		end
	end

	def destroy
		session[:admin_id] = nil
		redirect_to root_url, notice: "Logged Out!"
	end 
end
