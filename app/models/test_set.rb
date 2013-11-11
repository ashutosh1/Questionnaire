class TestSet < ActiveRecord::Base
  require 'zip'
  include Audit
  # CR_Priyank: We do not need to call concern with scope name
  include RestrictiveDestroy
  include GetRandomQuestions
  include GenerateSets

  has_and_belongs_to_many :questions
  validates :name, :instruction, presence: true
  
  has_permalink :name, :unique => true

  def file_name
    name.strip.gsub(" ", "_")
  end

  def destroyable?
    return false
  end

end
