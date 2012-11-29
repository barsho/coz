require 'spec_helper'

describe "Post pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let!(:p1) { FactoryGirl.create(:project, user: user, name: "Foo") }
  let!(:c1) { p1.conversations.create(title: "Loo Loo") }
  let!(:post1) { user.posts.create( conversation: c1, content: "baaa") }

  before { sign_in user }

  describe "post creation" do
    before { visit project_path(p1) }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Post, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do

      before { fill_in 'post[content]', with: "Lorem ipsum" }
      it "should create a post" do
        expect { click_button "Post" }.to change(Post, :count).by(1)
      end
    end
  end
  
  describe "post destruction" do
    before { user.posts.create( conversation: c1, content: "baaa3") }

    describe "as correct user" do
      before { visit project_path(p1) }

      it "should delete a post" do
        expect { click_link "delete" }.to change(Post, :count).by(-1)
      end
    end
  end
end
