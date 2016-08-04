require_relative '../../lib/extended/tag_extend.rb'
ActsAsTaggableOn::Tag.send(:include, TagExtend)
