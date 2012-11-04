require 'spec_helper'

describe Conversation do
  
  
  let(:user) { FactoryGirl.create(:user) }

  before { 
    @user = user
    @project = user.projects.create(name: "Lorem ipsum") 

    @conversation = @project.conversations.build(title: "Sample convo")
  }

  subject { @conversation }

  it { should respond_to(:title) }
  it { should respond_to(:conversationable_id) }

  it { should be_valid }

  describe "when conversationable_id is not present" do
    before { @conversation.conversationable_id = nil }
    it { should_not be_valid }
  end

  describe "accessible attributes" do
     it "should not allow access to conversationable_id" do
       expect do
         Conversation.new(conversationable_id: @project.id)
       end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
     end    
   end
   
   describe "when project_id is not present" do
     before { @conversation.conversationable_id = nil }
     it { should_not be_valid }
   end

   describe "with blank title" do
     before { @conversation.title = " " }
     it { should_not be_valid }
   end

   describe "with title that is too long" do
     before { @conversation.title = "a" * 141 }
     it { should_not be_valid }
   end
end
 