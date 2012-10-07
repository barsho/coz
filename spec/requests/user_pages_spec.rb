require 'spec_helper'

describe "UserPages" do

  subject { page }
  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1',    text: user.firstname) }
    it { should have_selector('title', text: user.firstname) }
  end
  
  describe "signup page" do
    before { visit signup_path }

#    it { should have_selector('div',    text: 'signup') }
    it { should have_selector('title', text: full_title('signup')) }
  
    let(:submit) { "signup" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "user_firstname",         with: "Example"
        fill_in "user_lastname",         with: "User"
        fill_in "user_email",        with: "user@example.com"
        fill_in "user_password",     with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
         before { click_button submit }
         let(:user) { User.find_by_email('user@example.com') }

         it { should have_selector('title', text: user.firstname) }
         it { should have_selector('div.alert.alert-success', text: 'welcome to coz') }
         it { should have_link('Sign out') }
       
       end
    end
  
  end
end
