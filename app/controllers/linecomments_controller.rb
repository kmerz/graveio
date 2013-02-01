class LinecommentsController < ApplicationController
 include PostsHelper

 def json_hash(post, comment)
   @comments = post.linecomments.find_all_by_line(comment.line)  
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

 def create
   @post = Post.find(params[:post_id])
   @comment = @post.linecomments.create(params[:linecomment])

   respond_to do |format|
     if @comment.errors.any?
       format.json { render :json =>
         {
           :error => @comment.errors.full_messages
         }
       }
     else
       format.json { render :json => json_hash(@post, @comment) }
     end
   end
 end
  
end
