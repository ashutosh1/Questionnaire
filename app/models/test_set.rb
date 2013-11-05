class TestSet < ActiveRecord::Base
  include Audit
  
  has_and_belongs_to_many :questions
end
