class Option < ActiveRecord::Base
  include Audit
  
  belongs_to :question
  validates :option, presence: true  
 end
