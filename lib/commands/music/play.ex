defmodule Musique.Commands.Music.Play do
  @moduledoc false
  alias Musique.Utilities
  alias Nostrum.Voice

  import Nostrum.Struct.Embed

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
    case Utilities.get_voice_channel_of_interaction(interaction) do
      nil ->
        [
          content: "You must be in a voice channel for me to join",
          ephemeral?: true
        ]

      vc_id ->
        case Utilities.bot_in_voice_channel?(interaction.guild_id, vc_id) do
          true ->
            # get video metadata here (with some ytpdl wrapper)
            [
              type: {:deferred_channel_message_with_source, {&deferred/1, [interaction]}}
            ]

          false ->
            Voice.join_channel(interaction.guild_id, vc_id)

            [
              type: {:deferred_channel_message_with_source, {&deferred/1, [interaction]}}
            ]
        end
    end
  end

  @impl true
  def type, do: :slash

  def deferred(%Nostrum.Struct.Interaction{} = interaction) do
    %{value: url} = List.first(interaction.data.options)

    {_s, v_title} = Exyt.get_title(url)
    {_s, v_thumb} = Exyt.get_thumbnail(url)
    {_s, v_duration} = Exyt.get_duration(url)

    Utilities.play_when_ready(interaction.guild_id, url, :ytdl)

    embed =
      %Nostrum.Struct.Embed{
        thumbnail: %Nostrum.Struct.Embed.Thumbnail{
          url: v_thumb,
          height: 1200,
          width: 800
        }
      }
      |> put_color(16_734_313)
      |> put_title("Now Playing")
      |> put_field("Title", v_title)
      |> put_field("Duration", v_duration)

    # Nostrum.Api.create_interaction_response!(interaction, [embeds: [embed]])

    [
      embeds: [embed]
    ]
  end
end
