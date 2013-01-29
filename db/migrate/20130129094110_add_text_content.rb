class AddTextContent < ActiveRecord::Migration
  def up
    Post.all.each do | p |
      if p.content_type == "None"
        p.content_type = "Text"
        p.save
      end
    end
  end

  def down
    Post.all.each do | p |
      if p.content_type == "Text"
        p.content_type = "None"
        p.save
      end
    end
  end
end
