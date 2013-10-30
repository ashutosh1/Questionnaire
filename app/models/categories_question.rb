class CategoriesQuestion < ActiveRecord::Base
  belongs_to :question
  belongs_to :category

  has_paper_trail ignore: [:created_at, :updated_at]
end
