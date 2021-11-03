defmodule Servo.Controllers.MessageController do
  def index(req) do
    # get most recent mesages from the cache
    messages = recent_messages()
  end
  
  def create(req, params) do
    # TODO: implement create action
  end
end
