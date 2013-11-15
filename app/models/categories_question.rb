class CategoriesQuestion < ActiveRecord::Base
  include UpdateQuestionsCount
  
  belongs_to :question
  belongs_to :category

end
