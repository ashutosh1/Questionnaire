class Option < ActiveRecord::Base
  belongs_to :question
  validates :option, presence: true

  scope :subjective_answers, -> { where(answer: nil)  }
  scope :mcq_answer, -> { where(answer: true)  }
  
  has_paper_trail ignore: [:created_at, :updated_at]
end
