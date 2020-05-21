class Work < ApplicationRecord
  validates :title, presence: true, uniqueness: { scope: :category }
   
  has_many :votes
  has_many :users, through: :votes

  def self.top_works(category)
    where(category: category).sort{ |a, b| b.votes.count <=> a.votes.count }.first(10)
    # result = Work.left_outer_joins(:votes)
    #                .group('works.id')
    #                .order('count(user_id) desc, title asc').limit(10)
  end

  def self.spotlight
    # look at votes
    # create a collection ofworks with max votes
    # pick the last one
    all.sort{ |a, b| b.votes.count <=> a.votes.count }.first
  end
end