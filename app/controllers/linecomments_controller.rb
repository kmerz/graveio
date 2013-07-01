class LinecommentsController < ApplicationController
 include PostsHelper

 def new
   @post = Post.find(params[:post_id])
   @line = params[:line]
   render :partial => 'linecomments/new'
 end

 def create
   @post = Post.find(params[:post_id])
   @comment = @post.linecomments.create(params.require(:linecomment).permit!)

   respond_to do |format|
     format.json {
       if @comment.errors.any?
         render :json => { :error => @comment.errors.full_messages }
       else
         render :json => json_hash(@post, @comment)
       end
     }
   end
 end

 private

 def json_hash(post, comment)
   @comments = post.linecomments.where(:line => comment.line)
   @line = comment.line
   html = render_to_string :template => "linecomments/_line_comment",
     :formats => :html, :layout => false
   return {
     :notice => "saved comment",
     :line => comment.line,
     :count => @comments.size,
     :html => html
   }
 end
end
