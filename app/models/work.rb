class Work < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  has_many :votes
  has_many :users, through: :votes

  def self.top_works(category)
    where(category: category).sample(10)
  end

  def self.spotlight
    # look at votes
    # create a collection ofworks with max votes
    # pick the last one
  end
end