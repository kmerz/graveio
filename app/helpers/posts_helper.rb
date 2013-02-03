module PostsHelper

  def preview_content(post)
    options = { options: {encoding: 'utf-8'} }
    if Pygments::Lexer.find(post.content_type)
      options.merge!(lexer: post.content_type.downcase)
    end
    lines = post.content.split("\n")
    lines[Post.MaxPreviewLines] = "..." if lines.size >= Post.MaxPreviewLines
    Pygments.highlight(lines[0..Post.MaxPreviewLines].join("\n"), options)
  end

  def colorized_content(post)
    options = { options: {encoding: 'utf-8'} }
    if Pygments::Lexer.find(post.content_type)
      options.merge!(lexer: post.content_type.downcase)
    end
    @lines = Pygments.highlight(post.content, options)[
      %r{<div class="highlight"><pre>(.*?)</pre>\s*</div>}m, 1
      ].split("\n")
    @linecomments = post.linecomments

    return render :partial => 'linecomments/line_comment_table'
  end
end
