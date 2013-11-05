require 'spec_helper'

describe UserMailer do
  let(:user1) { mock_model(User, save: true, id: 1, email: "ashutosh.tiwari@vinsol.com") }
  let(:user2) { mock_model(User, save: true, id: 2, email: "ashutosh@vinsol.com") }
  let(:role) { mock_model(Role, save: true, id: 1, name: User::ROLES.first) }

  describe 'send_account_creation_mail' do
    def call_send_account_creation_mail
      UserMailer.send_account_creation_mail(user1, user2)
    end
    
    before do 
      @roles = [role]
      user1.stub(:roles).and_return(@roles)
      @roles.stub(:join).with(' and').and_return(role.name)

    end
  
    it { call_send_account_creation_mail.to.should eq([user1.email]) }
    it { call_send_account_creation_mail.from.should eq([user2.email]) }
    it { call_send_account_creation_mail.cc.should eq([user2.email]) }
    it { call_send_account_creation_mail.body.encoded.should include(role.name) }
    
    context "assigned" do 
      it { call_send_account_creation_mail.subject.should eq("[#{Rails.env}] You have been added on Questionnaire as #{role.name}") }
    end
  end
end
