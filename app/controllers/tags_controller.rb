class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.all.token_input_tags
	render :json => @tags
  end

  def show
    @tag =  ActsAsTaggableOn::Tag.find(params[:id])
    @posts = Post.tagged_with(@tag.name)
  end

# def filter
#	@tag = ActsAsTaggableOn::Tag.filter(params[:query])
#	respond_to do |format|
#	  format.html { render :filter }
#	end
# end
end
