class Work < ApplicationRecord
  def self.top_works(category)
    where(category: category).sample(10)
  end
end
