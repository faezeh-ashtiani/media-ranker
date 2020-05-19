class AllowCascadeDeleteForVotes < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :votes, :works
    remove_foreign_key :votes, :users
    add_foreign_key :votes, :works, on_delete: :cascade
    add_foreign_key :votes, :users, on_delete: :cascade
  end
end
