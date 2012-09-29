require 'spec_helper'

describe "Static pages" do

  describe "Splash page" do

    it "should have the content 'coz'" do
      visit '/static_pages/splash'
      page.should have_content('coz')
    end
    it "should have the title 'selam'" do
      visit '/static_pages/splash'
      page.should have_selector('title',
                        :text => "selam.coz")
    end
  end

end