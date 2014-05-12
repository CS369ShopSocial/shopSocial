class FriendshipsController < ApplicationController
	def create
		@friendship = current_user.friendships.build(:friend_id => params[:friend_id])
		if @friendship.save
			flash[:success] = "Friend Request Sent"
			redirect_to current_user
		else
			flash[:error] = "Unable to Send Request"
			redirect_to root_url
		end
	end

	def destroy

		@friendship = Friendship.find(params[:id])
		@reverse = Friendship.find_by user_id: @friendship.friend_id
		if (@reverse)
			if (@reverse.friend_id == @friendship.user_id)
				@reverse.destroy
			end
		end
		@friendship.destroy
		flash[:notice] = "Friend Removed"
		redirect_to current_user
	end
end
