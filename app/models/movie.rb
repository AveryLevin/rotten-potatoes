class Movie < ActiveRecord::Base
  def self.all_ratings
    Movie.distinct.pluck(:rating)
  end
  
  def self.with_ratings(filter_ratings)
    Movie.all.where(rating: filter_ratings)
  end
end
