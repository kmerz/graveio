class PostsController < ApplicationController
  require 'tempfile'

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
    if params[:post][:upload_file]
      @post = Post.new
      data = params[:post].delete(:upload_file)

      if data.content_type != "text/plain" 
        @post.errors.add(:upload_file,
          "invalid content type: #{data.content_type}")
      end
      if data.size > 102400 # 100kb
        @post.errors.add(:upload_file,
          "file too large: #{data.size}")
      end
      if @post.errors.any?
        respond_to do |format|
          format.html { render action: "new" }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
        return
      end

      content_type = 'None'
      content = data.read.force_encoding("UTF-8")
      Tempfile.open(['uploaded', data.original_filename.downcase],
        Rails.root.join('tmp')) do |f|
        f.print(content)
        f.flush
        unless Linguist::FileBlob.new(f.path).language.nil?
          content_type = Linguist::FileBlob.new(f.path).language.name
        end
      end
      params[:post][:content_type] = content_type
      unless params[:post][:content].empty?
        params[:post][:content] << "\n\n"
      end
      params[:post][:content] << content
      
      if params[:post][:title].empty?
        params[:post][:title] = data.original_filename
      end
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
end
