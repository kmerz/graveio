class TagsController < ApplicationController
  protect_from_forgery

  def index
    query = params[:q]
    if query[-1,1] == " "
      query = query.gsub(" ", "")
      params[:q] = query
      Tag.find_or_create_by_name(query)
    end
    @tags = Tag.where("name like ?", "%#{params[:q]}%")

    respond_to do |format|
      format.json { render :json => @tags.map(&:attributes) }
    end
  end

end
