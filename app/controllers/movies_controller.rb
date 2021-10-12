class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    filtered_ratings = params[:ratings] 
    sort_by = params[:sort_by]
    @all_ratings = Movie.all_ratings
    
    if filtered_ratings == nil
      # if ratings filter not passed in param, attempt to use saved filter
      if session[:filtered_ratings] == nil
        filtered_ratings = @all_ratings
      else
        filtered_ratings = session[:filtered_ratings]
      end
    else
      filtered_ratings = filtered_ratings.keys
    end
    
    if sort_by == nil
      # if sort_by not passed in param, attempt to use save sort_by
      sort_by = session[:sort_by]
    end
    
    @movies = Movie.with_ratings(filtered_ratings, sort_by)
    @ratings_to_show = filtered_ratings
    
    if sort_by == 'title'
      @title_hdr_class = 'hilite bg-warning'      
    elsif sort_by == 'release_date'
      @release_hdr_class = 'hilite bg-warning'
    end
      
    # save the session
    session[:filtered_ratings] = filtered_ratings
    session[:sort_by] = sort_by
    
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
