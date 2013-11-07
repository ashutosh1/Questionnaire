class Question < ActiveRecord::Base
  include Taggable
  include Audit
  
  has_and_belongs_to_many :test_sets
  has_many :categories_questions, dependent: :destroy
  has_many :categories, through: :categories_questions
  # CR_Priyank: Options and anwers association/logic doesn't seems fine, revisit
  has_many :options, dependent: :destroy
  has_many :answers, -> { where.not(answer: false)  }, class_name: 'Option'
  
  belongs_to :user
  belongs_to :question_type
  belongs_to :question_level

  validates :question, :question_type, :question_level, :user, presence: true
  
  # CR_Priyank: Validation for exactly one answer and multiple options to be present for mcq
  # CR_Priyank: Validation for atleast one answer and multiple options to be present for mcaq
  # CR_Priyank: Validation for exactly one answer and exactly one option to be present for subjective question

  validate :validate_categories

  scope :published, -> { where.not(published_at: nil) }
  scope :unpublished, -> { where(published_at: nil) }

  accepts_nested_attributes_for :categories_questions, allow_destroy: true
  accepts_nested_attributes_for :options, allow_destroy: true, reject_if: proc { |attributes| attributes['option'].blank? }
  
  # CR_Priyank: published? can be an alias method of published_at?
  def published?
    published_at?
  end

  # CR_Priyank: setting published_at can be done without calling callbacks and validations
  def publish
    update_attributes(published_at: Time.now)
  end

  # CR_Priyank: setting published_at can be done without calling callbacks and validations
  def unpublish
    update_attributes(published_at: nil)
  end

  def destroyable_by_user?(current_user)
    # CR_Priyank: User::ROLES.first may not be safe, instead use :super_admin directly
    user == current_user || current_user.has_role?(User::ROLES.first.to_sym)
  end

  def validate_categories
    errors.add(:base, "Please select at least one category.") if categories_questions.blank?
  end
end
