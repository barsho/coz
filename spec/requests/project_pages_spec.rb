require 'spec_helper'

describe "Project pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  
  
  before { sign_in user }

  describe "project creation" do
    before { visit newproject_path }

    describe "with invalid information" do

      it "should not create a project" do
        expect { click_button "create" }.not_to change(Project, :count)
      end

    end

    describe "with valid information" do

      before { fill_in 'project_name', with: "Lorem ipsum" }
      it "should create a project" do
        expect { click_button "create" }.to change(Project, :count).by(1)
      end
    end
  end
  
  describe "project destruction" do
    before { @project = FactoryGirl.create(:project, user: user) }

    describe "as correct user" do
      before { visit project_path(@project) }

      it "should delete a project" do
        expect { click_link "remove" }.to change(Project, :count).by(-1)
      end
    end
  end
  
  describe "show page" do
    let(:project) { FactoryGirl.create(:project) }
    let!(:c1) { FactoryGirl.create(:conversation, conversationable: project, title: "Foo") }
    let!(:c2) { FactoryGirl.create(:conversation, conversationable: project, title: "Bar") }

    before { visit project_path(project) }

    it { should have_selector('title', text: project.id.to_s()) }

    describe "conversations" do
      it { should have_content(c1.title) }
      it { should have_content(c2.title) }
      it { should have_content(project.conversations.count) }
    end
    
    describe "feed" do
      before do
        FactoryGirl.create(:conversation, conversationable: project, title: "Lorem ipsum")
        FactoryGirl.create(:conversation, conversationable: project, title: "Dolor sit amet")
        visit project_path(project)
 
      end

      it "should render the project's feed" do
        project.feed.each do |item|
          page.should have_content(item.title)
        end
      end
    end
  end
end