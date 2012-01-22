require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'json'

# only in dev mode
require "sinatra/reloader"

require_relative 'Game'

class StoredGame
    include DataMapper::Resource
    
    property :id,     Serial
    property :title,  String, :length => 255, :default => "Unnamed game"
    property :board,  Object, :lazy => true 
    # todo connection between players & robots, roles
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

# index
get '/' do        
    result = '<a href="/new_game">new game</a><br>
     <a href="/games">games</a><br>'

    StoredGame.all.each { |game| result += "<br><a href=\"games/#{game.id}\">#{game.id}</a>" }     
     
    result
end


# create a new game
get '/new_game' do    
    
    game = StoredGame.new()
    game.title = "Katzenjammer"
    #game.board = Game.new()
    game.board = Game.create([["Le Lw", "Cs Pw", "_ Ww"], ["R", "", ""], ["", "", ""]])
        
    halt(500, "Game was not created #{game.errors.inspect}") unless game.save

    content_type 'application/json'
    {'id' => game.id }.to_json
end


# list all games
get '/games' do
    games = StoredGame.all
    results = {}    
    games.each { |game| results["#{game.id}"] = game.title }

    content_type 'application/json'
    results.to_json
end

get '/games/:id' do    

    id = params[:id].to_i    
    game = StoredGame.get(id)
        
    halt(404, 'Game not found') if game.nil?   
    
    content_type 'application/json' 
    { 'title' => game.title, 'board' => game.board.board }.to_json
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
