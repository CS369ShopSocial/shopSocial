require 'spec_helper'

describe "Articles" do

  subject { page }
  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit articles_path
    end

    it { should have_title('All articles') }
    it { should have_content('All articles') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:article) } }
      after(:all)  { Article.delete_all }

      it "should list each Article" do
        Article.paginate(page: 1).each do |article|
          expect(page).to have_selector('li', text: article.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before(:all) { 30.times { FactoryGirl.create(:article) } }
        after(:all)  { Article.delete_all }
        before do
          sign_in admin
          visit articles_path
        end

        it { should have_link('Create an Article', href: '/articles/new') }
        it { should have_link('delete', href: article_path(Article.first)) }
        it "should be able to delete an article" do
          expect do
            click_link('delete', match: :first)
          end.to change(Article, :count).by(-1)
        end
      end
    end
  end
end
