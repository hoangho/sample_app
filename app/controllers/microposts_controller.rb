class MicropostsController < ApplicationController
	def index
	end

	def create
		@micropost = current_user.microposts.build(params[:micropost])
		if @micropost.save
			flash[:success] = "Creat post successlly"
			redirect_to user_path(current_user)
		else
			flash[:error] = "Create post failed with errors#{@micropost.errors.full_messages}"
			redirect_to user_path(current_user)
		end
	end

	def edit
		@micropost = Micropost.find(params[:id])
	end

	# def update
	# 	@micropost = Micropost.new(params[:micropost])
	# 	if @micropost.update_attributes
	# 	else
	# 	end
	# end
	def destroy
		@micropost = Micropost.find(params[:id])
		if @micropost.destroy
			flash[:success] = "Delete post successlly"
			redirect_to user_path(current_user)
		else
			flash[:error] = "Delete post failed"
			redirect_to user_path(current_user)
		end
	end
end
