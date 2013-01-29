module PostsHelper
  require 'tempfile'

  def get_content_type(data)
    content_type = 'None'
    Tempfile.open(['uploaded', data.original_filename.downcase],
      Rails.root.join('tmp')) do |f|
      # set executable bits so Linguist will check for shebangs
      f.chmod(0755)
      f.print(content)
      f.flush
      unless Linguist::FileBlob.new(f.path).language.nil?
        content_type = Linguist::FileBlob.new(f.path).language.name
      end
    end
    return content_type
  end
end
