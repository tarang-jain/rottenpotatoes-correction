class Movie < ActiveRecord::Base
  def self.with_ratings(l)
    where(rating: l)
  end
end
