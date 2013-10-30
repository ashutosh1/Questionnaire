class Category < ActiveRecord::Base
  include RestrictiveDestroy

  auto_strip_attributes :name

  #All children are destroyed as well (default) if any node is destroyed
  has_ancestry

  has_many :categories_questions, dependent: :destroy
  has_many :questions, through: :categories_questions
  
  validates :name, presence: true, uniqueness: { scope: :ancestry }
  has_paper_trail ignore: [:created_at, :updated_at]

end
