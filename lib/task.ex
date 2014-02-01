defmodule Mix.Tasks.Start do
  use Mix.Task

  def run(_) do
    Echo.Server.start(6000)
  end
  
end
