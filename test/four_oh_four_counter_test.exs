defmodule FourOhFourCounterTest do
  use ExUnit.Case
  
  alias Servo.FourOhFourCounter, as: Counter
  
  test "reports counts of missing path requests" do
    Counter.start()
    
    Counter.inc("/terminator")
    Counter.inc("/robocop")
    Counter.inc("/robocop")
    Counter.inc("/terminator")
    Counter.inc("/robocop")
    
    assert Counter.get_count("/robocop") == 3
    assert Counter.get_count("/terminator") == 2
    
    assert Counter.get_counts == %{ "/terminator" => 2, "/robocop" => 3 }
  end
end
