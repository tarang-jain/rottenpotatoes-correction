class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    @ratings_to_show = []
    @title_css = ""
    @date_css = ""
    if params[:ratings] != nil
      session[:ratings] = params[:ratings].keys()
    end
    if params[:sortkey] == 'title'
      session[:sortkey] = 'title'
      @title_css = "hilite bg-warning"
    elsif params[:sortkey] == 'release_date'
      session[:sortkey] = 'release_date'
      @date_css = "hilite bg-warning"
    end

    if params[:sortkey] == nil && params[:ratings] == nil && (session[:sortkey] || session[:ratings])
      redirect_to movies_path(:ratings => Hash[session[:ratings].map{|r| [r, "1"]}], :sortkey => session[:sortkey])
    end

    if session[:ratings] != nil
      @ratings_to_show = session[:ratings]
    else
      @ratings_to_show = @all_ratings
    end

    @movies = Movie.with_ratings(@ratings_to_show)

    if session[:sortkey] == 'title'
      @movies = @movies.order('title ASC')
    elsif session[:sortkey] == 'release_date'
      @movies = @movies.order('release_date ASC')
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
