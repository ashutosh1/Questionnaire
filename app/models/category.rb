class Category < ActiveRecord::Base
  auto_strip_attributes :name

  before_destroy :destroyable?

  #All children are destroyed as well (default) if any node is destroyed
  has_ancestry

  has_many :categories_questions, dependent: :destroy
  has_many :questions, through: :categories_questions
  
  validates :name, presence: true, uniqueness: { scope: :ancestry }

  private
    def destroyable?
      questions.blank? && !descendants.includes(:questions).map{|c| c.questions.blank?}.include?(false)
    end

end
