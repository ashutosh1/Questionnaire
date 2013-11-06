class CategoriesQuestion < ActiveRecord::Base
  include Audit
  
  belongs_to :question
  belongs_to :category

  before_destroy :destroyable?

  def destroyable?
    raise "at least one category should be present, you can not remove this category" if question.categories_questions.size == 1
  end
end
