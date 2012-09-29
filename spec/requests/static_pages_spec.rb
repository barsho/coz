require 'spec_helper'

describe "Static pages" do

  describe "Splash page" do
    
    subject { page }
    before { visit root_path } 

    it { should have_selector('img', id: 'splashLogo') }
    it { should have_selector('title', text: full_title(''))}
  
  end

end