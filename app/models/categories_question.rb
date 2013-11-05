class CategoriesQuestion < ActiveRecord::Base
  include Audit
  
  belongs_to :question
  belongs_to :category
end
