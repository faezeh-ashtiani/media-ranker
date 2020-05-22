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
    sorted = all.sort do |a, b|
      vote_check = b.votes.count <=> a.votes.count # if they are the same (the result of the spaceship comparigon is 0)
      !vote_check.zero? ? vote_check : a.title <=> b.title
    end
    sorted.first
  end
end
