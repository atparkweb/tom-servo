defmodule Servo.BotView do
  require EEx

  alias Servo.Request
  
  @templates_path Path.expand("../../templates", __DIR__)
  
  EEx.function_from_file :def, :index, Path.join(@templates_path, "index.eex"), [:bots]
  EEx.function_from_file :def, :show, Path.join(@templates_path, "show.eex"), [:bot]
  
  defp render(req, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template) 
      |> EEx.eval_file(bindings)

    %Request{ req | status: 200, res_body: content }
  end

end
