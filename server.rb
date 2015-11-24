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

alistair = Butler.new('movies')

get '/actors' do
  sql_query = "SELECT * FROM actors ORDER BY name ASC"
  @actors = alistair.read(sql_query)
  erb :'actors/index'
end

get '/actors/:id' do
  # actor_id = params[:id]
  sql_query = %Q(
    SELECT a.name AS actor, m.title AS movie, c.character AS character
    FROM actors a
    JOIN cast_members c ON a.id = c.actor_id
    JOIN movies m ON c.movie_id = m.studio_id
    WHERE a.id = #{params[:id]})

  @actor = alistair.read(sql_query).first
  erb :'actors/show'
end
