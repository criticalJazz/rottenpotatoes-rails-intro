class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.get_possible_ratings

    unless params[:ratings].nil?
    
      @rating_filter = params[:ratings]
      session[:rating_filter] = @rating_filter
      
    end

   
    if params[:working_sort].nil?
  
    else
      session[:working_sort] = params[:working_sort]
    end

    if params[:working_sort].nil? && params[:ratings].nil? && session[:rating_filter]
      
      @rating_filter = session[:rating_filter]
      @working_sort = session[:working_sort]
    
      flash.keep
      redirect_to movies_path({order_by: @working_sort, ratings: @rating_filter})
      
    end
    
    @movies = Movie.all

    if session[:rating_filter]
      
      @movies = @movies.select{ |movie| session[:rating_filter].include? movie.rating }
      
    end

    
    if session[:working_sort] == "title"
    

      @movies = @movies.sort! { |a, b| a.title <=> b.title }

      @movie_highlight = "hilite"
      
    elsif session[:working_sort] == "release_date"
      

      @movies = @movies.sort! { |a, b| a.release_date <=> b.release_date }

      @date_highlight = "hilite"
      
    else
      
    end
	
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
