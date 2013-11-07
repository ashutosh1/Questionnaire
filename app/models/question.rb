class Question < ActiveRecord::Base
  include Taggable
  include Audit
  
  has_and_belongs_to_many :test_sets
  has_many :categories_questions, dependent: :destroy
  has_many :categories, through: :categories_questions
  has_many :options, dependent: :destroy
  has_many :answers, -> { where(answer: true)  }, class_name: 'Option'
  
  belongs_to :user
  belongs_to :question_type
  belongs_to :question_level

  validates :question, :question_type, :question_level, :user, presence: true
  validate :validate_categories

  scope :published, -> { where.not(published_at: nil) }
  scope :unpublished, -> { where(published_at: nil) }

  accepts_nested_attributes_for :categories_questions, allow_destroy: true
  accepts_nested_attributes_for :options, allow_destroy: true, reject_if: proc { |attributes| attributes['option'].blank? }
   
  def published?
    published_at?
  end

  def publish
    update_attributes(published_at: Time.now)
  end

  def unpublish
    update_attributes(published_at: nil)
  end

  def destroyable_by_user?(current_user)
    user == current_user || current_user.has_role?(User::ROLES.first.to_sym)
  end

  def validate_categories
    errors.add(:base, "Please select at least one category.") if categories_questions.blank?
  end
end
