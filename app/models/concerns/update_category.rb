module UpdateCategory
  extend ActiveSupport::Concern

  included do
    before_save :update_category
    attr_accessor :category_field  
  end
  
  def update_category
    if category_field.present?
      catg_ids = category_field.split(",")
      category_should_remove = categories_questions.collect(&:category_id) - catg_ids
      category_should_remove.each{|cat| categories.delete(cat)} if catg_ids
      catg_ids.each{|id| categories_questions.build(category_id: id)}
    end
  end

end
