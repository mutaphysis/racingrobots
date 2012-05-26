require_relative '../Game'

describe Game, "#marshalling" do
  it "copying should save the instance fields" do
    game = Game.create([["Le Lw", "Cs Pw", "_ Ww"], ["R", "", ""], ["", "", ""]])
    r = game.create_robot()
    game.place_robot(r, 1, 1)
    game.turn = 2
    
    data = Marshal.dump(game)
    copy = Marshal.load(data)
    
    copy.turn.should == 2
    copy.board[0][0].length.should == 2
    copy.board[0][0][0].should be_an_instance_of Laser
    copy.board[0][0][0].direction.should == :east
    copy.board[0][0][1].should be_an_instance_of Laser
    copy.board[0][0][1].direction.should == :west
    
    # instances should be the same
    copy.robots[0].should === copy.board[1][1][0] 
  end
end
