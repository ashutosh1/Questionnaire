class CategoriesQuestion < ActiveRecord::Base
  include Audit
  
  belongs_to :question, inverse_of: :categories_questions
  belongs_to :category
end
