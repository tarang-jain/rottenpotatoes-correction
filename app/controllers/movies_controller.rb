class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    @ratings_to_show = []
    if params[:ratings] != nil
      @ratings_to_show = params[:ratings].keys()
    end
    if @ratings_to_show != []
      @movies = Movie.with_ratings(@ratings_to_show)
    else
      @movies = Movie.with_ratings(@all_ratings)
    end

    @title_css = ""
    @date_css = ""

    if params[:sortkey] == 'title'
      @movies.order('release_date ASC')
      @title_css = "hilite bg-warning"
    elsif params[:sortkey] == 'release_date'
      @movies.order('release_date ASC')
      @date_css = "hilite bg-warning"
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
