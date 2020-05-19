class RelateUsersAndWorksToVotes < ActiveRecord::Migration[6.0]
  def change
    add_reference :votes, :work, index: true, foreign_key: true
    add_reference :votes, :user, index: true, foreign_key: true
  end
end
