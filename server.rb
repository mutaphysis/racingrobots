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

# start a new game
get '/new_game' do    
  content_type 'application/json'
    
  game = StoredGame.new()
  game.title = "Katzenjammer"
  game.board = Game.create([["Ce", "Csr", "We Wn _"], ["", "Cs", ""], ["Ws Ww _", "Csl", "Ce"]])
        
  halt(500, "Game was not created #{game.errors.inspect}") unless game.save
    
  '{ "result" : "ok" }'
end

# list all games
get '/games' do    
  content_type 'application/json'
  games = StoredGame.all
  results = games.collect { |game| {'title' => game.title, 'url' => "http://localhost:4567/#{game.id}" } }
    
  results.to_json
end

# display a game
get '/games/:id' do    
  content_type 'application/json'

  id = params[:id].to_i    
  game = StoredGame.get(id)
        
  halt(404, 'Game not found') if game.nil?    
    
  result = ""
  game.board.board.each do |row| 
    row.each do |tiles| 
      tiles.each do |tile|
        result << tile.class.name[0] << tile.direction[0] << " " 
      end
      result << "\t\t"
    end
    result << "\n"
  end

  result
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
