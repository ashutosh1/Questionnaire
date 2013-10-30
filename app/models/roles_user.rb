class RolesUser < ActiveRecord::Base
  belongs_to :role 
  belongs_to :user

  validates :role_id, uniqueness: {scope: :user_id}
  has_paper_trail ignore: [:created_at, :updated_at]
end