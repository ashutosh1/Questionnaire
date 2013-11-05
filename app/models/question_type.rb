class QuestionType < ActiveRecord::Base
  include RestrictiveDestroy
  include Audit

  auto_strip_attributes :name
  
  has_many :questions
  validates :name, presence: true, uniqueness: true
end
