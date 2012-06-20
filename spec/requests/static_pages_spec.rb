require 'spec_helper'

describe "StaticPages" do
  base_title = "Ruby on Rails Tutorial Sample App"

  # When we have to repeat many times of this we define it as a macro for using in future
  shared_examples_for  "all static pages" do 
    it { should have_selector('h1', :text => heading ) }
    it { should have_selector('title', :text=> full_title(page_title))}
  end
  
  # Use it as a prefix for condition
  subject{ page }

  describe "Home page" do
    before { visit root_path }
      let(:heading) { 'Welcome to the sample app' }
      let(:page_title) { 'Home' }
      it_should_behave_like "all static pages"
      it { should_not have_selector('title', :text=> full_title(' Home'))}
  end


  describe "Help page" do
  	before { visit help_path }
      let(:heading) { 'Help' }
      let(:page_title) { 'Help' }
      it_should_behave_like "all static pages"
      it { should_not have_selector('title', :text=> full_title(' Help'))}
  end

  describe "About page" do
    before { visit about_path }
        let(:heading) { 'About Us' }
        let(:page_title) { "About Us" }
        it_should_behave_like "all static pages"
        it { should_not have_selector('title', :text=> full_title(" About Us"))}
  end

  describe "Contact Page" do
    before { visit contact_path }
      let(:heading) { "Contact Us" }
      let(:page_title) { "Contact Us" }
      it_should_behave_like "all static pages"
      it { should_not have_selector('title', :text=> full_title(' Contact Us'))}
  end

  # test for clicking on a link in the home page
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About Us')
    click_link "Help"
    page.should  have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should  have_selector 'title', text: full_title('Contact Us')
    click_link "Home"
    click_link "Sign up now!"
    page.should  have_selector 'title', text: full_title('Signup')
    click_link "sample app"
    page.should  have_selector 'title', text: full_title('Home')
  end

end
