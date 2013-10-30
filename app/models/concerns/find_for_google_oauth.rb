module FindForGoogleOauth
  extend ActiveSupport::Concern

  module ClassMethods
    def find_for_google_oauth2(auth, signed_in_resource=nil)
      if (user = User.where(email: auth[:info][:email], name: auth[:info][:name], provider: auth[:provider], uid: auth[:uid]).first).present?
        return user
      elsif (user = User.where(email: auth[:info][:email]).first).present?
        user.update_attributes(name: auth[:info][:name], provider: auth[:provider], uid: auth[:uid] )
      else
        user = nil
      end
      user 
    end
  end
end