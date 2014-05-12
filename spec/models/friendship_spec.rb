require 'spec_helper'

describe Friendship do

	let(:user) { FactoryGirl.create(:user) }
  	let(:friend) { FactoryGirl.create(:user) }
  	let(:friendship) { user.friendships.build(friend_id: friend.id) }


	describe "when user_id is not present" do
		before { friendship.user_id = nil }
		it { should_not be_valid }
	end

	describe "when friend_id is not present" do
		before { friendship.friend_id = nil }
		it { should_not be_valid }
	end
end
