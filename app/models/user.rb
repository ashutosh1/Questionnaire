class User < ActiveRecord::Base
  devise :omniauthable, :omniauth_providers => [:google_oauth2]
  
  validates :email, presence: true
  validates :email, format: { :with => EMAIL_REGEX }, allow_blank: true

  has_and_belongs_to_many :roles
  has_many :questions
  
  ROLES = %w[super_admin admin]
  
  #implement mandrill for mail functionality
  #after_create :send_email_to_user

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
      UserMailer.delay.send_account_creation_mail(self)
    end

end
