class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:destroy]
	# GET /posts
  # GET /posts.json
  def index
    @users = User.all
  end

# GET /posts/1
  # GET /posts/1.json
	def show
    @user = User.find(params[:id])
    if current_user
       @micropost = current_user.microposts.build
     else
      store_location
      redirect_to signin_path
    end
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
      sign_in @user
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

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      sign_in @user
      flash[:success] = "User profile was updated successfully"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "Delete user #{@user.name} successfully"
      redirect_to users_path
    else
      # flash[:error] = "Delete user #{@user.name} failed"
      # redirect_to root_path
    end
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in" unless signed_in?
      end
    end

    def correct_user
      if User.all.any? { |user| user.id.to_s == params[:id] }
        @user = User.find(params[:id])
        redirect_to root_path unless current_user?(@user)
      else
        redirect_to root_path, notice: "The page your requested does not existed"
      end
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
