require 'spec_helper'

describe "AuthenticationPages" do
	subject{ page }
  describe "signin page" do
    before { visit signin_path }
    it { should have_selector('h1',text: 'Sign in') }
    it { should have_selector('title', text: full_title('Sign in')) }
  end
  describe "with invalid information" do
  	before do 
  		visit signin_path
  		click_button "Sign in"
  	end
  	it { should have_selector('title', text: full_title('Sign in'))}
  	it { should have_selector('div.alert.alert-error', text: 'Invalid') }
  	 describe "after visit other page" do
  	before { click_link "Home"}
  	it { should_not have_selector('div.alert.alert-error', text: 'Invalid') }
  	end
  end

 
  describe "with valid information" do
  	let(:user) { FactoryGirl.create(:user) }
  	before { sign_in user }
  	it { should have_selector('title', text: full_title(user.name)) }
    it { should have_link('Users', href: users_path) }
  	it { should have_link('Profile', href: user_path(user)) }
  	it { should have_link('Sign out', href: signout_path) }  
    it { should have_link('Settings', href: edit_user_path(user) ) }  

    describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "visiting the following page" do
          before { visit following_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "visiting the followers page" do
          before { visit followers_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

      end
    end
  end

  describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "before user signed in" do
      it { should_not have_link('Users', href: users_path) }
      it { should_not have_link('Profile', href: user_path(user)) }
      it { should_not have_link('Sign out', href: signout_path) }  
      it { should_not have_link('Settings', href: edit_user_path(user) ) }  

      end

      describe "in the Microposts controller" do

        describe "submitting to the create action" do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          sign_in user
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('h1',text: 'Edit profile')
          end
        end

         # check when user sigin again
        describe "when user signin again" do
          before { sign_in user }
          it "should render the default (profile) page" do
              page.should have_selector('title', text: user.name) 
          end
        end


      end
  end

  # check for delete action
  describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }        
      end
    end

  describe "as admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      before { sign_in admin }
      describe "cannot delete him self " do
        before { delete user_path(admin) }
        specify { response.should redirect_to(root_path) }
      end
  end

 
end
