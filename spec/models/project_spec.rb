# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Project do
  
  let(:user) { FactoryGirl.create(:user) }

  before { 
    @project = user.projects.build(name: "Lorem ipsum") 
    @user = user
  }

  subject { @project }

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }  
  
  it { should respond_to(:conversations) }
  it { should respond_to(:feed) }

  it { should respond_to(:child_conversation) }
  
  it { should be_valid }

  describe "when user_id is not present" do
    before { @project.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Project.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "conversation associations" do

     before { @project.save }
     let!(:older_conversation) do 
       FactoryGirl.create(:conversation, conversationable: @project,  created_at: 1.day.ago)
     end
     let!(:newer_conversation) do
       FactoryGirl.create(:conversation, conversationable: @project, created_at: 1.hour.ago)
     end 

     it "should have the right microposts in the right order" do
       @project.conversations.should == [ newer_conversation, older_conversation]
     end
     
     it "should destroy associated microposts" do
       conversations = @project.conversations.dup
       @project.destroy
       conversations.should_not be_empty
       conversations.each do |conversation|
         Conversation.find_by_id(conversation.id).should be_nil
       end
     end
     
     describe "status" do
       let(:unfollowed_conversation) do
         FactoryGirl.create(:conversation, conversationable: FactoryGirl.create(:project))
       end

       its(:feed) { should include(newer_conversation) }
       its(:feed) { should include(older_conversation) }
       its(:feed) { should_not include(unfollowed_conversation) }
     end
  end
  
  describe "project associations" do

    before { @user.save }
    let!(:older_project) do 
      FactoryGirl.create(:project, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_project) do
      FactoryGirl.create(:project, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right projects in the right order" do
      @user.projects.should == [@project, newer_project, older_project]
    end
  end
  
  describe "when user_id is not present" do
    before { @project.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank name" do
    before { @project.name = " " }
    it { should_not be_valid }
  end

  describe "with name that is too long" do
    before { @project.name = "a" * 141 }
    it { should_not be_valid }
  end
end
