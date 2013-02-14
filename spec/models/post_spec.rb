# == Schema Information
#
# Table name: posts
#
#  id              :integer          not null, primary key
#  content         :string(255)
#  user_id         :integer
#  conversation_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Post do

  let(:user) { FactoryGirl.create(:user) }
  let(:project) { user.projects.create(name: "hello") }
  let(:conversation) { project.conversations.create( title: "yallo") }
  before { 
    @post = user.posts.build(content: "Lorem ipsum") 
    @post.conversation = conversation
  }
  
  subject { @post }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }
  it { should respond_to(:child_conversation) }
    
  it { should be_valid }
  

  
  describe "when user_id is not present" do
    before { @post.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Post.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when user_id is not present" do
    before { @post.user_id = nil }
    it { should_not be_valid }
  end

  describe "when conversation_id is not present" do
    before { @post.conversation_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @post.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @post.content = "a" * 141 }
    it { should_not be_valid }
  end

  describe "it should save" do
    it { @post.save.should be_true }
  end

  describe "after save it should have child conversation" do
    before { @post.save }
    it { @post.child_conversation.should be_valid }
  end
end
