class TestSet < ActiveRecord::Base
  has_and_belongs_to_many :questions
  has_paper_trail ignore: [:created_at, :updated_at]
end
