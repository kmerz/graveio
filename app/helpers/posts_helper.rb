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

end
