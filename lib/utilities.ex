defmodule Musique.Utilities do
  @moduledoc """
  Handy utilities for Musique
  """

  require Logger
  alias Nostrum.Cache.GuildCache
  alias Nostrum.Cache.Me
  alias Nostrum.Voice

  @spec play_when_ready(non_neg_integer(), any(), :pipe | :raw | :raw_s | :stream | :url | :ytdl) ::
          :ok | {:error, <<_::312, _::_*80>>}
  @doc """
  Handshake with Discord servers before playing the requested URL
  """
  def play_when_ready(guild_id, url, type, opts \\ []) do
    if Voice.ready?(guild_id) do
      Voice.play(guild_id, url, type, opts)
    else
      # Wait for handshaking to complete
      Process.sleep(25)
      play_when_ready(guild_id, url, type, opts)
    end
  end

  @spec try_play(non_neg_integer(), any(), :pipe | :raw | :raw_s | :stream | :url | :ytdl) :: :ok
  @doc """
  Alternative to play_when_ready
  """
  def try_play(guild_id, url, type, opts \\ []) do
    case Voice.play(guild_id, url, type, opts) do
      {:error, msg} ->
        # Wait for handshaking to complete
        Process.sleep(100)
        try_play(guild_id, url, type, opts)

        Logger.error(msg)

      _ ->
        :ok
    end
  end

  @spec get_voice_channel_of_interaction(%{
          :guild_id => non_neg_integer(),
          :user => %{:id => any(), optional(any()) => any()},
          optional(any()) => any()
        }) :: any()
  def get_voice_channel_of_interaction(%{guild_id: guild_id, user: %{id: user_id}} = _interaction) do
    guild_id
    |> GuildCache.get!()
    |> Map.get(:voice_states)
    |> Enum.find(%{}, fn v -> v.user_id == user_id end)
    |> Map.get(:channel_id)
  end

  def bot_in_voice_channel?(guild_id, vc_id) do
    bot_id = Me.get().id

    guild_id
    |> GuildCache.get!()
    |> Map.get(:voice_states)
    |> Enum.any?(fn v -> v.user_id == bot_id and v.channel_id == vc_id end)
  end
end
