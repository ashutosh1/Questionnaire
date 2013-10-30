class User
  module SendEmail
    extend ActiveSupport::Concern

    included do
      after_create :send_account_creation_mail
    end

    def send_account_creation_mail
      current_user = Thread.current[:audited_admin]
      UserMailer.delay.send_account_creation_mail(self, current_user)
    end
    
  end
end