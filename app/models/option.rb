class Option < ActiveRecord::Base
  include Audit
  
  belongs_to :question
  validates :option, presence: true

  scope :subjective_answers, -> { where(answer: nil)  }
  scope :mcq_answer, -> { where(answer: true)  }
  
 end
