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
       before { sign_in user }

       it { should have_selector('title', text: user.firstname) }
       it { should have_link('Profile', href: user_path(user)) }
       it { should have_link('Settings', href: edit_user_path(user)) }
       it { should have_link('Sign out', href: signout_path) }
       it { should have_link('Users',    href: users_path) }
       it { should_not have_link('login', href: signin_path) }
       
       describe "followed by signout" do
         before { click_link "Sign out" }
         it { should have_link('login') }
       end
       
     end
  end
  
  describe "authorization" do
    
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }        
      end
    end
    
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      
      describe "in the Conversations controller" do

         describe "submitting to the create action" do
           before { post conversations_path }
           specify { response.should redirect_to(signin_path) }
         end

         describe "submitting to the destroy action" do
           before { delete conversation_path(FactoryGirl.create(:conversation)) }
           specify { response.should redirect_to(signin_path) }
         end
       end
       
       describe "in the Posts controller" do

        describe "submitting to the create action" do
          before { post posts_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete post_path(FactoryGirl.create(:post)) }
          specify { response.should redirect_to(signin_path) }
        end
      end
      
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "session_email",    with: user.email
          fill_in "session_password", with: user.password
          click_button "login"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: 'settings')
          end
        end
      end
      
      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'login') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
        
        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'login') }
        end
      end
    end
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('settings')) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end