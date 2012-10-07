require 'spec_helper'

describe "UserPages" do

  subject { page }
  
  describe "index" do
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.firstname)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end
  
  
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
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end
    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "settings") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end
    
    describe "with valid information" do
      let(:new_firstname)  { "Newfirstname" }
      let(:new_lastname)  { "Newlastname" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "user_firstname",        with: new_firstname
        fill_in "user_lastname",        with: new_lastname
        fill_in "user_email",            with: new_email
        fill_in "user_password",         with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_firstname) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.firstname.should  == new_firstname }
      specify { user.reload.email.should == new_email }
    end
  end
  
end
