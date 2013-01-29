class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    last = params[:last].blank? ? Time.now + 1.second :
      Time.parse(params[:last])
    @posts = Post.feed(last)
    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.text { render :text => @post.content }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    if params[:post][:author].blank? && user_signed_in?
      params[:post][:author] = current_user.email
    end
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html {
          redirect_to @post, notice: 'Post was successfully created.'
        }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    old_post = Post.find(params[:id])
    @post = old_post.create_version(params[:post])

    respond_to do |format|
      if @post.save
        old_post.likedislikes.all.each { |l| l.post_id = @post.id; l.save}
        format.html {
          redirect_to @post, notice: 'New version of snippet was created.'
        }
        format.json { head :no_content }
      else
        old_post.errors = @post.errors
        @post = old_post
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  # GET /help
  def help
    @server_ip = request.remote_addr || "172.16.0.255"
    @server_port = request.port || "80"
    respond_to do |format|
      format.html { render :help }
    end
  end

  # GET /search
  def search
    @posts = Post.search(params[:query])
    respond_to do |format|
      format.html { render :search }
    end
  end

  def diff
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html { render :diff }
    end
  end

  def like_json(post)
   likes = post.likedislikes.find_all_by_liked(true)
   dislikes = post.likedislikes.find_all_by_liked(false)
   liker = likes.collect { |l| User.find(l.liker).email }.join(", ")
   disliker = dislikes.collect { |l| User.find(l.liker).email }.join(", ")
   return { 
     :postid => post.id,
     :likes => likes.size,
     :dislikes => dislikes.size,
     :liker => liker,
     :disliker => disliker
   }
  end

  def like
    @post = Post.find(params[:id])
    if user_signed_in?
      @like = @post.likedislikes.find_by_liker(current_user.id)
      if @like.nil?
        @like = @post.likedislikes.new()
        @like.liker = current_user.id
      elsif @like.liked == true
        @like.destroy
        respond_to do |format|
          format.json { render :json => like_json(@post) }
        end
        return
      end
      @like.liked = true
      if @like.save
        respond_to do |format|
          format.json { render :json => like_json(@post) }
        end
      else
        respond_to do |format|
          format.json { render json: @post.errors,
            status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.json { render :json => {
          :errors => "You have to be logged in." }
        }
      end
    end
  end
  
  def dislike
    @post = Post.find(params[:id])
    if user_signed_in?
      @like = @post.likedislikes.find_by_liker(current_user.id)
      if @like.nil?
        @like = @post.likedislikes.new()
        @like.liker = current_user.id
      elsif @like.liked == false
        @like.destroy
        respond_to do |format|
          format.json { render :json => like_json(@post) }
        end
        return
      end
      @like.liked = false
      if @like.save
        respond_to do |format|
          format.json { render :json => like_json(@post) }
        end
      else
        respond_to do |format|
          format.json { render json: @post.errors,
            status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.json { render :json => {
          :errors => "You have to be logged in." }
        }
      end
    end
  end
end
