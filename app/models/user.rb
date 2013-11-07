class User < ActiveRecord::Base
  include SendEmail
  include FindForGoogleOauth
  include Audit

  devise :omniauthable, :omniauth_providers => [:google_oauth2]
  
  validates :email, presence: true, uniqueness: true
  # CR_Priyank: Only vinsol's email ID can be saved in email
  validates :email, format: { :with => EMAIL_REGEX }, allow_blank: true
  
  has_many :roles_users, dependent: :destroy
  has_many :roles, through: :roles_users
  has_many :questions

  ROLES = %w[super_admin admin]
  
  attr_readonly :email
  accepts_nested_attributes_for :roles_users, allow_destroy: true

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

end
