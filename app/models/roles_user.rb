class RolesUser < ActiveRecord::Base
  include Audit

  belongs_to :role 
  belongs_to :user

  validates :role_id, uniqueness: {scope: :user_id}
end
