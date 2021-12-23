defmodule FourOhFourCounterTest do
  use ExUnit.Case

  alias Servo.FourOhFourCounter, as: Counter

  describe "counts 404 requests" do

    setup do
      pid = Counter.start()
      on_exit(fn ->
        Process.exit(pid, :kill)
      end)
      {:ok, counter: Counter, pid: pid}
    end

    test "reports counts of missing path requests" do
      Counter.inc("/terminator")
      Counter.inc("/robocop")
      Counter.inc("/robocop")
      Counter.inc("/terminator")
      Counter.inc("/robocop")

      assert Counter.get_count("/robocop") == 3
      assert Counter.get_count("/terminator") == 2

      assert Counter.get_counts == %{ "/terminator" => 2, "/robocop" => 3 }
    end

    test "resets counts" do
      Counter.inc("/killroy")
      Counter.inc("/killroy")
      Counter.inc("/robo")
      Counter.inc("/robo")
      assert Counter.get_counts == %{ "/robo" => 2, "/killroy" => 2 }

      Counter.reset()
      assert Counter.get_counts == %{}
    end
  end
end
