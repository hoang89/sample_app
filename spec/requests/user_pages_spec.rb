	require 'spec_helper'

describe "User Pages" do
subject{ page }
  # check index page should have list of user
  describe "index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }
    


    it "should list each user" do
      User.all.each do |user|
        page.should have_selector('li', text: user.name)
      end
    end
  end

  # check index pages should have pagination 
  describe "index" do

    let(:user) { FactoryGirl.create(:user) }

    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all)  { User.delete_all }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    describe "pagination" do

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    # Check just admin can see delete links
    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
      end
  end

  # check for content of sign up page
  describe "signup pages" do
  	before{ visit signup_path }
    it { should have_selector('h1',:text => "Sign up")}
    it { should have_selector('title',text: 'Sign up') }
  end

  # check for content of profile page
  describe "profile page" do
  # Code to make a user variable
  let(:user) { FactoryGirl.create(:user) }
  let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Test content 1") }
  let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Test content 2") }
  
  before { visit user_path(user) }

  it { should have_selector('h1', text: user.name) }
  it { should have_selector('title', text: user.name) }
  describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
end

# check for sign up validation
describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }
    # for valid info
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      describe "after submission" do
        before { click_button submit }
        it { should have_selector('h1', title: 'Signup')}
        it { should have_content('error')}
      end
    end

    # for invalid info
    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      # for content after sign up success
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Successfully created user') }
        it { should have_link('Sign out') }
      end
    end
  end

  # check for edit action
  describe "edit action" do
    let(:user) { FactoryGirl.create(:user) }
    before do 
      sign_in user
      visit edit_user_path(user) 
    end

    describe "page" do
      it { should have_selector('h1',text: "Edit profile") }
      it { should have_selector('title', text: full_title("Edit")) }
      it { should have_link('change', href: 'http://gravatar.com/emails')}  
    end
    
    describe "with invalid information" do
      before {click_button "Save change"}

      it { should have_content('error') } 
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
    
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit user')) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end

  describe "signed in" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user}
         describe "user cannot create new " do
           before { put signup_path }
           it { should have_content('sample app') }
           specify { response.should redirect_to(root_path) }
         end
      
        describe "user cannot use create action " do
          before { put signup_path }
          it { should have_content('sample app') }
          specify { response.should redirect_to(root_path) }
        end
  end

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_selector('title', text: full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_selector('title', text: full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end
end
