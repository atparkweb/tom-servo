defmodule Servo.Resources.Bot do
  defstruct id: nil, name: "", color: "", is_active: true
  
  def order_by_name_asc(bot1, bot2) do
    bot1.name <= bot2.name
  end
end
