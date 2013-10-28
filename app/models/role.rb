class Role < ActiveRecord::Base
  has_many :roles_users, dependent: :destroy
  has_many :users, through: :roles_users

  validates :name, presence: true, uniqueness: true
  validates :name, inclusion: { in: User::ROLES, message: "%{value} is not a valid role" }, allow_blank: true

end
