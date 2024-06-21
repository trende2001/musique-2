defmodule Musique.Commands.Music.Queue do
  @moduledoc false
  alias Musique.Core.ETS

  import Nostrum.Struct.Embed

  require Logger

  @behaviour Nosedrum.ApplicationCommand

  @spec name() :: String.t()
  def name(), do: "queue"

  @impl true
  def description(), do: "Query current videos in the queue"

  @impl true
  def command(%Nostrum.Struct.Interaction{} = interaction) do
    [
      type: {:deferred_channel_message_with_source, {&deferred/1, [interaction]}}
    ]
  end

  @impl true
  def type(), do: :slash

  def deferred(%Nostrum.Struct.Interaction{} = interaction) do
    queue =
      ETS.get(interaction.guild_id)
      |> case do
        [] -> []
        [{_key, q}] -> q
      end

    if queue == [] do
      [
        content: "The queue is currently empty",
        ephemeral?: true
      ]
    else
      embed =
        %Nostrum.Struct.Embed{}
        |> put_color("16734313")
        |> put_title("Current Queue")
        |> put_description(format_queue(queue))

      [
        embeds: [embed]
      ]
    end
  end

  defp format_queue(queue) do
    Enum.with_index(queue, 1)
    |> Enum.map(fn {url, index} -> "#{index}. #{url}" end)
    |> Enum.join("\n")
  end
end
