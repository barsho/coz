require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('title', text: 'login') }
  end
  
  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "login" }

      it { should have_selector('title', text: 'login') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link 'coz'  }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end
    
    describe "with valid information" do
       let(:user) { FactoryGirl.create(:user) }
       before do
         fill_in "session_email",    with: user.email
         fill_in "session_password", with: user.password
         click_button "login"
       end

       it { should have_selector('title', text: user.firstname) }
       it { should have_link('Profile', href: user_path(user)) }
       it { should have_link('Sign out', href: signout_path) }
       it { should_not have_link('login', href: signin_path) }
       
       describe "followed by signout" do
         before { click_link "Sign out" }
         it { should have_link('login') }
       end
       
     end
  end
end