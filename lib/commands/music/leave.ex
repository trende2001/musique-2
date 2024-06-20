defmodule Musique.Commands.Music.Leave do
  alias Musique.Utilities
  alias Nostrum.Voice

  require Logger

  @behaviour Nosedrum.ApplicationCommand

  def name(), do: "leave"

  @impl true
  def description(), do: "Leave the current channel bot is in."


  @impl true
  def command(%Nostrum.Struct.Interaction{} = interaction) do
    case Utilities.get_voice_channel_of_interaction(interaction) do
      nil ->
        [
          content: "I'm not in a voice channel",
          ephemeral?: true
        ]

      _vc_id ->
        Voice.leave_channel(interaction.guild_id)
        [
          content: "Left your voice channel"
        ]
    end
  end

  @impl true
  def type(), do: :slash
end
