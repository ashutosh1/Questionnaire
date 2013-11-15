class Question < ActiveRecord::Base
  include Taggable
  include Audit
  include UpdateCategory
  include UpdateQuestionsCount
  
  QUESTION_TYPE = {:Subjective => "Subjective", :Mcq => "Multiple_choice_questions", :Mcqma => "Multiple_choice_multiple_answer_questions"}
  has_and_belongs_to_many :test_sets
  has_many :categories_questions, dependent: :destroy
  has_many :categories, through: :categories_questions
  # CR_Priyank: Options and anwers association/logic doesn't seems fine, revisit
  has_many :options, dependent: :destroy
  has_many :answers, -> { where(answer: true)  }, class_name: 'Option'
  
  belongs_to :user
  belongs_to :question_level
  # validates_presence_of :categories_questions, message: "Please select at least one category"
  validates :question, :type, :question_level, :user, presence: true
  
  scope :published, -> { where.not(published_at: nil) }
  scope :unpublished, -> { where(published_at: nil) }
  
  accepts_nested_attributes_for :options, allow_destroy: true, reject_if: proc { |attributes| attributes['option'].blank? }
  
  # CR_Priyank: published? can be an alias method of published_at?
  alias_attribute :published, :published_at

  scope :question_with_type, lambda{|typ| where(type: typ) if typ}

  # CR_Priyank: setting published_at can be done without calling callbacks and validations
  def publish!
    update_column(:published_at, Time.current)
  end

  # CR_Priyank: setting published_at can be done without calling callbacks and validations
  def unpublish!
    update_column(:published_at, nil) if test_sets.blank?
  end

  def destroyable_by_user?(current_user)
    # CR_Priyank: User::ROLES.first may not be safe, instead use :super_admin directly
    user == current_user || current_user.has_role?(:super_admin)
  end

end
