defmodule Musique.Commands.Music.Resume do
  @moduledoc false
  alias Musique.Utilities
  alias Nostrum.Voice

  require Logger

  @behaviour Nosedrum.ApplicationCommand

  def name, do: "resume"

  @impl true
  def description, do: "Pause the current track"

  @impl true
  def command(%Nostrum.Struct.Interaction{} = interaction) do
    case Utilities.get_voice_channel_of_interaction(interaction) do
      nil ->
        [
          content: "I'm not in a voice channel",
          ephemeral?: true
        ]

      _vc_id ->
        if !Voice.playing?(interaction.guild_id), do:
          Voice.resume(interaction.guild_id)

        [
          content: "Resumed current track"
        ]
    end
  end

  @impl true
  def type, do: :slash
end
