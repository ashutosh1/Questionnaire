class QuestionType < ActiveRecord::Base
  auto_strip_attributes :name
  
  has_many :questions
  validates :name, presence: true, uniqueness: true

  before_destroy :destroyable?  

  private
    def destroyable?
      questions.blank?
    end
end
