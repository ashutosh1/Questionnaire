class Question < ActiveRecord::Base
  has_many :options
  has_many :subjective_answers, -> { where(answer: nil)  }, class_name: 'Option'
  has_many :mcq_answer, -> { where(answer: true)  }, class_name: 'Option'
  has_many :answers, -> { where.not(answer: false)  }, class_name: 'Option'
  has_and_belongs_to_many :test_sets
  has_many :categories_questions
  has_many :categories, through: :categories_questions

  belongs_to :user
  belongs_to :question_type
  belongs_to :question_level
end
