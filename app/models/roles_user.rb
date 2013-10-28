class RolesUser < ActiveRecord::Base
  belongs_to :role 
  belongs_to :user

  validates :role, uniqueness: {scope: :user}
end