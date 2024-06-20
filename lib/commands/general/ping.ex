defmodule Musique.Commands.General.Ping do
  require Logger

  import Nostrum.Struct.Embed

  alias Nostrum.Util

  @behaviour Nosedrum.ApplicationCommand

  def name, do: "ping"

  @impl true
  def description, do: "Ping the bot to check for lifesigns."

  @impl true
  def command(%Nostrum.Struct.Interaction{} = _interaction) do
    latencies =
      Util.get_all_shard_latencies()
      |> Map.values()

    latency = Enum.sum(latencies) / length(latencies)

    embed =
      %Nostrum.Struct.Embed{}
      |> put_title("Pong! 🏓")
      |> put_description("#{Decimal.normalize(Decimal.from_float(latency))}ms")

    [
      embeds: [embed]
    ]
  end

  @impl true
  def type, do: :slash
end
