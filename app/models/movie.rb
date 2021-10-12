class Movie < ActiveRecord::Base
  def self.all_ratings
    Movie.distinct.pluck(:rating)
  end
  
  def self.with_ratings(filter_ratings, sort_by)
    if sort_by != nil
      Movie.all.where(rating: filter_ratings).order(sort_by)
    else 
      Movie.all.where(rating: filter_ratings)
    end
  end
end
