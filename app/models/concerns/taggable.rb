module Taggable
  extend ActiveSupport::Concern

  included do
    acts_as_taggable
    before_save :add_tags
    attr_accessor :tags_field  
  end

  def add_tags
    tag_should_remove = tag_list - tags_field.split(",")
    tag_list.remove(tag_should_remove)
    tag_list.add(tags_field.split(","))
  end

end