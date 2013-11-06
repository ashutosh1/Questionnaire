require 'zip'
class TestSet < ActiveRecord::Base
  include Audit
  include TestSet::RestrictiveDestroy
  include TestSet::GetRandomQuestions
  include GenerateSets

  has_and_belongs_to_many :questions
  validates :name, :instruction, presence: true
  
  after_save :create_number, :unless => :number?

  def file_name
    name.strip.gsub(" ", "_")
  end

  private
    def create_number
      update_column(:number, id.to_s.rjust(6,'0'))
    end

end
