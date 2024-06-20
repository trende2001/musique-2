defmodule Musique.Core.App do
  use Application

  def start(_type, _args) do
    children = [
      Nosedrum.Storage.Dispatcher,
      Musique.Core.EventConsumer,
      Musique.Core.ETS
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
