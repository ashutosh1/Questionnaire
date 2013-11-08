require 'zip'
class TestSet < ActiveRecord::Base
  include Audit
  include TestSet::RestrictiveDestroy
  include TestSet::GetRandomQuestions
  include GenerateSets

  has_and_belongs_to_many :questions
  validates :name, :instruction, presence: true
  
  has_permalink :name, :unique => true

  def file_name
    name.strip.gsub(" ", "_")
  end

end
