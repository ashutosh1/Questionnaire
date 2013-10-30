class Question < ActiveRecord::Base
  
  has_and_belongs_to_many :test_sets
  has_many :categories_questions, dependent: :destroy
  has_many :categories, through: :categories_questions
  has_many :options
  has_many :answers, -> { where.not(answer: false)  }, class_name: 'Option'
  
  belongs_to :user
  belongs_to :question_type
  belongs_to :question_level

  validates :question, :question_type, :question_level, :user, presence: true

  scope :published, -> { where.not(published_at: nil) }
  scope :unpublished, -> { where(published_at: nil) }

  accepts_nested_attributes_for :categories_questions, allow_destroy: true
  accepts_nested_attributes_for :options, allow_destroy: true, reject_if: proc { |attributes| attributes['option'].blank? }
  
  has_paper_trail ignore: [:created_at, :updated_at]
  acts_as_taggable
  ActsAsTaggableOn.force_lowercase = true
   
  def published?
    published_at?
  end

  def publish
    update_attributes(published_at: Time.now)
  end

  def unpublish
    update_attributes(published_at: nil)
  end
end
