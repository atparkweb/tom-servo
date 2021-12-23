defmodule Servo.View do
  require EEx

  alias Servo.Request

  @templates_path Path.expand("../../templates", __DIR__)

  def render(req, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template) 
      |> EEx.eval_file(bindings)

    %Request{ req | status: 200, res_body: content }
  end
end
