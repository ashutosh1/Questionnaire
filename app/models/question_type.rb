class QuestionType < ActiveRecord::Base
  auto_strip_attributes :name
  
  before_destroy :destroyable?  
  
  has_many :questions, dependent: :destroy
  validates :name, presence: true, uniqueness: true

  private
    def destroyable?
      questions.blank?
    end
end
