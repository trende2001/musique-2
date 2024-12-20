defmodule Musique.Core.App do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      Nosedrum.Storage.Dispatcher,
      Musique.Core.EventConsumer,
      Musique.Queue
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
