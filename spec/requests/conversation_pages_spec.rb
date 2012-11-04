require 'spec_helper'

describe "ConversationPages" do
  subject { page }

   let(:user) { FactoryGirl.create(:user) }
   let(:project) { user.projects.create(name: "hello") }  
   
   before { sign_in user }

   describe "conversation creation" do
     before { visit project_path(project) }

     describe "with invalid information" do

       it "should not create a conversatoin" do
         expect { click_button "Post" }.not_to change(Conversation, :count)
       end

       describe "error messages" do
         before { click_button "Post" }
         it { should have_content('error') } 
       end
     end

     describe "with valid information" do

       before { fill_in 'conversation_title', with: "Lorem ipsum" }
       it "should create a conversation" do
         expect { click_button "Post" }.to change(Conversation, :count).by(1)
       end
     end
   end
   
   describe "conversation destruction" do
    before {  FactoryGirl.create(:conversation, conversationable: project, title: "Lorem ipsum") }

    describe "as correct user" do
      before { visit project_path(project) }

      it "should delete a conversation" do
        expect { click_link "delete" }.to change(Conversation, :count).by(-1)
      end
    end
  end
end
