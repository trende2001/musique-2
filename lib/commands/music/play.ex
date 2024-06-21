defmodule Musique.Commands.Music.Play do
  @moduledoc false
  alias Musique.Queue
  alias Musique.Utilities
  alias Nostrum.Voice


  require Logger

  @behaviour Nosedrum.ApplicationCommand

  @spec name :: String.t()
  def name, do: "play"

  @impl true
  def description, do: "Play a YouTube video in a voice channel"

  @impl true
  @spec options :: [
          %{description: <<_::208>>, name: <<_::24>>, required: true, type: :string},
          ...
        ]
  def options,
    do: [
      %{
        type: :string,
        name: "url",
        description: "URL to play the audio from",
        required: true
      }
    ]

  @impl true
  def command(%Nostrum.Struct.Interaction{} = interaction) do
    %{value: opt_url} = List.first(interaction.data.options)

    case Utilities.get_voice_channel_of_interaction(interaction) do
      nil ->
        [
          content: "You must be in a voice channel for me to join",
          ephemeral?: true
        ]

      vc_id ->
        case Utilities.bot_in_voice_channel?(interaction.guild_id, vc_id) do
          true ->
            Queue.add(interaction.guild_id, opt_url)

            [
              type: {:deferred_channel_message_with_source, {&deferred/1, [interaction]}}
            ]

          false ->
            Voice.join_channel(interaction.guild_id, vc_id)
            Queue.add(interaction.guild_id, opt_url)

            [
              type: {:deferred_channel_message_with_source, {&deferred/1, [interaction]}}
            ]
        end
    end
  end

  @impl true
  def type, do: :slash

  def deferred(%Nostrum.Struct.Interaction{} = interaction) do
    Queue.play_next(interaction.guild_id)
  end
end
