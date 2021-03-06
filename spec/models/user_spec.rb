# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  firstname       :string(255)
#  lastname        :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

require 'spec_helper'

describe User do




  before { 
    @user = User.new(firstname: "Example", lastname: "User", email: "user@example.com", 
                            password: "foobar")   
  }

  subject { @user }

  it { should respond_to(:firstname) }
  it { should respond_to(:lastname) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }

  it { should respond_to(:admin) }

  it { should respond_to(:authenticate) }
  it { should respond_to(:projects) }
  it { should respond_to(:conversations) }
  it { should respond_to(:child_conversation) }
  it { should respond_to(:posts) }
  

    
  it { should be_valid }
  it { should_not be_admin }
  
  describe "post associations" do

    before { 
      @user.save
      @project = @user.projects.create(name: "hello")
      @conversation = @project.conversations.create( title: "yallo")
    }
    
    let!(:older_post) do 
      FactoryGirl.create(:post, user: @user, conversation: @conversation, created_at: 1.day.ago)
    end
    let!(:newer_post) do
      FactoryGirl.create(:post, user: @user, conversation: @conversation, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      @user.posts.should == [older_post, newer_post]
    end
    
    it "should destroy associated microposts" do
      posts = @user.posts.dup
      @user.destroy
      posts.should_not be_empty
      posts.each do |post|
        Post.find_by_id(post.id).should be_nil
      end
    end
  end

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end
  describe "when firstname is not present" do
    before { @user.firstname = " " }
    it { should_not be_valid }
  end
  
  describe "when lastname is not present" do
    before { @user.lastname = " " }
    it { should_not be_valid }
  end
  
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when firstname is too long" do
    before { @user.firstname = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when lastname is too long" do
    before { @user.lastname = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end      
    end
  end
  
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end
  
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  
  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
    
    describe "remember token" do
      before { @user.save }
      its(:remember_token) { should_not be_blank }
    end
  end
end
