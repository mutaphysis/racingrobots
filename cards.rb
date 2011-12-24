initial_priority = 10
priority_increment = 10

seed_order = [:uturn, :rotateleft, :rotateright, :backup, :moveone, :movetwo, :movethree]
seed = {:uturn => 6, :rotateleft => 18, :rotateright => 18, :backup => 6, :moveone => 18, :movetwo => 12, :movethree => 6 }

$cards = []

seed_order.each do |k|  
  (0..seed[k]).each do |n|
    $cards << {:type => k, :priority => ($cards.length * priority_increment + initial_priority)}
  end
end