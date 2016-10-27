class Movie < ActiveRecord::Base

  # attr_accessor :title
  # attr_accessor :rating
  # attr_accessor :description
  # attr_accessor :release_date


  def self.get_possible_ratings
    
	  return %w[G PG PG-13 R]
	  
  end
	  
end