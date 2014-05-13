require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "friending" do
      describe "initially no friends" do
        describe "and no other users" do
          it { should_not have_content('Send Friend Request') }
          it { should have_content('This is You!') }
        end
        describe "then add a user" do
          before(:all) { @user2 = FactoryGirl.create(:user) }
          after(:all) { @user2.delete }
          it { should have_content('Send Friend Request') }
          describe "and send them a request" do
            before do
              click_link("Send Friend Request")
              click_link("Users")
            end
            it { should_not have_content('Send Friend Request') }
            it { should have_content('Friend Request Sent') }
            describe "also check other user's perspective" do
              before do
                click_link 'Sign out'
                sign_in @user2
                visit users_path
              end
              it { should_not have_content('Send Friend Request') }
              it { should have_content('Confirm Friend') }
              describe "and confirm friendship" do
                before do
                  click_link 'Confirm Friend'
                  visit users_path
                end
                it { should have_content('Friended') }
              end
            end
          end
        end
      end
    end

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

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
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') } 
    it { should have_title(full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
        it { should have_content('Name') }
        it { should have_content('Email can\'t') }
        it { should have_content('invalid') }
        it { should have_content('short') }
        it { should have_content('Password can\'t') }
      end
    end

    describe "with valid information" do

      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_link('Articles') }
        it { should have_title(user.name) }
        it { should have_selector ".alert", text: 'Welcome' } 

      end   
    end
  end

  describe "profile page" do
   let(:user) { FactoryGirl.create(:user) }
   before { visit user_path(user) }

   describe "friends list" do
    before do 
      sign_in(user)
    end
    it { should have_content('Friends List') }
    it { should have_content('Friend Requests')}
    describe "with friend request sent" do
      before do
        @user2 = FactoryGirl.create(:user)
        @friendship = user.friendships.build(:friend_id => @user2.id)
        @friendship.save
        visit user_path(user)
      end
      after { @user2.destroy }
      it { should have_content('request sent') }
      it { should have_link('remove') }
      describe "then removed" do
        before { click_link 'remove' }
        it { should_not have_content('request sent') }
        it { should_not have_link('remove') }
      end

      describe "from other users perspective" do
        before do
          sign_in(@user2)
          visit user_path(@user2)
        end
        it { should have_content('Friend Requests') }
        it { should have_content("#{user.name}") }
        it { should have_content('remove') }
        describe "then deleted by other user" do
          before { click_link 'remove' }
          it { should_not have_content("#{user.name}") }
          it { should_not have_content('remove') }
        end
      end

      describe "then confirmed" do
        before do 
          @friendship = @user2.friendships.build(:friend_id => user.id)
          @friendship.save
          visit user_path(user)
        end
        it { should_not have_content('request sent') }
        it { should have_content('remove') }
        describe "then removed" do
          before { click_link 'remove' }
          it { should_not have_content('remove') }
          describe "then seen by other user" do
            before do
              sign_in(@user2)
              visit user_path(@user2)
            end
            it { should_not have_content('remove') }
          end
        end

        describe "from other users perspective" do
          before do
            sign_in(@user2)
            visit user_path(@user2)
          end
          it { should have_content('Friend Requests') }
          it { should have_content("#{user.name}") }
          it { should have_content('remove') }
        end
      end
    end
  end

  it { should have_content(user.name) }
  it { should have_title(user.name) }
  it { should have_content('Search For Friends') }

  describe "should show only matching users for search" do
    let(:submit) { "Create my account" }

    before do
      fillin_with_name_and_email("Example User", "testuser1@example.com")
      fillin_with_name_and_email("Another User", "testuser2@example.com")

      sign_in(user)
      visit user_path(user)
      fill_in 'value', with: "Example"
      click_button "Search For Friends"
    end

    it { should have_content("Example") }
    it { should_not have_content("Another") }
  end
end

describe "edit" do
  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in user
    visit edit_user_path(user)
  end

  describe "forbidden attributes" do
    let(:params) do
      { user: { admin: true, password: user.password,
        password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

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

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end
end
