require_relative '../Game'

describe Game, "#marshalling" do
  it "copying should save the instance fields" do
    game = Game.create([["Le", "Cs Pw", "_ Ww"], ["R", "", ""], ["", "", ""]])
    game.turn = 2
    
    data = Marshal.dump(game)
    copy = Marshal.load(data)
    
    copy.turn.should == 2
    copy.board[0][0].length.should == 1
    copy.board[0][0][0].should be_an_instance_of Laser
  end
end
