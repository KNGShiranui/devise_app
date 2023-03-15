class BlogsController < ApplicationController
  before_action :set_blog, only: %i[show edit update destroy]
  before_action :authenticate_user!,  only: [:new, :edit, :update, :destroy]  # こうすると未ログインでも閲覧だけは可能

  def index
    @blogs = Blog.all.order(created_at: :desc).page(params[:page])
    # ページネーション導入
    # @blogs = Blog.all.includes(:user).order(created_at: :desc).page(params[:page])
    # お試し実装なのでここまでしなくてOK。
  end

  def show
    if @blog.status_private? && @blog.user != current_user
      respond_to do |format|
        format.html { redirect_to blogs_path, notice: 'このページにはアクセスできません' }
      end
    end
  end

  def new
    @blog = Blog.new
  end

  def edit
  end

  def create
    @blog = Blog.new(blog_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @blog.save
        format.html { redirect_to blog_url(@blog), notice: "新規投稿を行いました。" }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to blog_url(@blog), notice: "Blog was successfully updated." }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @blog.destroy

    respond_to do |format|
      format.html { redirect_to blogs_url, notice: "Blog was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  def set_blog
    @blog = Blog.find(params[:id])
  end

  def blog_params
    params.require(:blog).permit(:title, :content, :status)
    # params.require(:blog).permit(:title, :content, :status, {:cat_ids => []})
    # のようにするとcategoryのidも受け渡しできるようになる。今回は未使用。
  end
end
