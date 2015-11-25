require "sinatra"
require "pg"
require "pry"
require_relative "./app/models/butler"

set :views, File.join(File.dirname(__FILE__), "app/views")

configure :development do
  set :db_config, { dbname: "movies" }
end

configure :test do
  set :db_config, { dbname: "movies_test" }
end

def db_connection
  begin
    connection = PG.connect(Sinatra::Application.db_config)
    yield(connection)
  ensure
    connection.close
  end
end

alistair = Butler.new

get '/actors' do
  sql_query = "SELECT * FROM actors ORDER BY name ASC"
  @actors = alistair.fetch(sql_query)
  erb :'actors/index'
end

get '/actors/:id' do
  sql_query = %Q(
    SELECT a.name AS actor, c.character AS character, m.title AS title, m.id AS id
    FROM actors a
    JOIN cast_members c ON a.id = c.actor_id
    JOIN movies m ON c.movie_id = m.id
    WHERE a.id = #{params[:id]}
    )

  @actors = alistair.fetch(sql_query)
  erb :'actors/show'
end

get '/movies' do
  sql_query = %Q(
    SELECT m.id AS id, m.title AS title, m.year AS year, m.rating AS rating, g.name AS genre, s.name AS studio
    FROM movies m
    LEFT JOIN genres g ON g.id = m.genre_id
    LEFT JOIN studios s ON s.id = m.studio_id
    )

  @movies = alistair.fetch(sql_query)

  erb :'movies/index'
end

get '/movies/:id' do
  sql_query = %Q(
    SELECT m.id, m.title, m.year, m.rating, g.name AS genre, s.name AS studio, c.character, a.name, a.id AS actor_id
    FROM movies m
    LEFT JOIN cast_members c ON m.id = c.movie_id
    LEFT JOIN actors a ON c.actor_id = a.id
    LEFT JOIN genres g ON g.id = m.genre_id
    LEFT JOIN studios s ON s.id = m.studio_id
    WHERE m.id = #{params[:id]}
    )

  @movie = alistair.fetch(sql_query)

  erb :'movies/show'
end
