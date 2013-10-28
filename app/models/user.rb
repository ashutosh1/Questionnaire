class User < ActiveRecord::Base
  devise :omniauthable, :omniauth_providers => [:google_oauth2]
  
  validates :email, presence: true, uniqueness: true
  validates :email, format: { :with => EMAIL_REGEX }, allow_blank: true
  
  has_many :roles_users, dependent: :destroy
  has_many :roles, through: :roles_users
  has_many :questions
  
  ROLES = %w[super_admin admin]
  
  after_create :send_account_creation_mail
  
  attr_readonly :email
  accepts_nested_attributes_for :roles_users, allow_destroy: true

  def self.find_for_google_oauth2(auth, signed_in_resource=nil)
    if (user = User.where(email: auth.info.email, name: auth.info.name, provider: auth.provider, uid: auth.uid).first).present?
      return user
    elsif (user = User.where(email: auth.info.email).first).present?
      user.update_attributes(name: auth.info.name, provider: auth.provider, uid: auth.uid )
    else
      user = nil
    end
    user 
  end

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  private

    def send_account_creation_mail
      current_user = Thread.current[:audited_admin]
      UserMailer.delay.send_account_creation_mail(self, current_user)
    end

end
