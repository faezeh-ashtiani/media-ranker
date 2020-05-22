class Work < ApplicationRecord
  validates :title, presence: true, uniqueness: { scope: :category }
  
  has_many :votes
  has_many :users, through: :votes

  def self.top_works(category)
    where(category: category).sort{ |a, b| b.votes.count <=> a.votes.count }.first(10)
    # another way to do it that goes deep into the database (By Ansel the great (tutor))
    # result = Work.left_outer_joins(:votes)
    #                .group('works.id')
    #                .order('count(user_id) desc, title asc').limit(10)
  end

  def self.spotlight
    sort_by_votes = all.sort{ |a, b| b.votes.count <=> a.votes.count }
    sort_by_votes.sort{ |a, b| b.created_at <=> a.created_at }.first
  end
end