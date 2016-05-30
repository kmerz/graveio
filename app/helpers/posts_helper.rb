module PostsHelper

  def markdown(post)
    options = {
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(post.content).html_safe
  end

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
