class UsersController < ApplicationController
	# GET /posts
  # GET /posts.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

# GET /posts/1
  # GET /posts/1.json
	def show
    @user = User.find(params[:id])
  	end

  def new
  	@user = User.new

  	respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to the sample app"
      redirect_to @user
    else
      render 'new'
    end

    #Also work
    # respond_to do |format|
    #   if @user.save
    #     format.html { redirect_to @user, notice: 'User was successfully created.' }
    #     format.json { render json: @user, status: :created, location: @user }
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end
  end
end
