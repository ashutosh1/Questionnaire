class QuestionLevel < ActiveRecord::Base
  include RestrictiveDestroy
  
  auto_strip_attributes :name

  has_many :questions
  validates :name, presence: true, uniqueness: true
  has_paper_trail ignore: [:created_at, :updated_at]
end
