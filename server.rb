require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'json'

# only in dev mode
require "sinatra/reloader"

class StoredGame
    include DataMapper::Resource
    
    property :id,     Serial
    property :title,  String, :length => 255, :default => "Unnamed game"
    property :board,  Object, :lazy => true  
    
end

configure do
    # connect DataMapper to a local sqlite file.
    DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/development.sqlite3"));
    DataMapper.finalize
    DataMapper.auto_upgrade!
end

# always allow reading from a different server
before do
    response['Access-Control-Allow-Origin'] = '*'
    expires 500, :public, :must_revalidate
    
    #p request.body.read
end

# list all games
get '/new_game' do    
    content_type 'application/json'
    
    game = StoredGame.new()
    game.title = "Katzenjammer"
        
    halt(500, "Game was not created #{game.errors.inspect}") unless game.save
    
    p game
end


# list all games
get '/games' do    
    content_type 'application/json'
    games = StoredGame.all
    results = {}    
    games.each { |game| results["#{game.id}"] = game.title }
    
    results.to_json
end

# 404 handler
not_found do
  "404"
end
  
# @e holds whatever was thrown, for this example, a string, 
# but it could have an Error class of some sort.
error do
  request.env['sinatra_error']
end
