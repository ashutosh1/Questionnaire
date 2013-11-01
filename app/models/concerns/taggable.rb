module Taggable
  extend ActiveSupport::Concern

  included do
    acts_as_taggable
    ActsAsTaggableOn.force_lowercase = true
    before_save :add_tags
    attr_accessor :tags_field  
  end

  def add_tags
    tag_list.add(tags_field.split(",")) if tags_field.present?
  end

  def remove_tags(name)
    tag_list.remove(name)
    save
  end

end