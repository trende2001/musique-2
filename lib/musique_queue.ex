defmodule Musique.Queue do
  @moduledoc """
  Handles queue tables per guild. Includes ways to manipulate and query things from the assigned table.
  """
  alias Musique.Utilities
  alias Musique.Core.ETS

  import Nostrum.Struct.Embed

  def add(guild_id, url) do
    queue = ETS.get(guild_id) |> case do
      [] -> []
      [{_key, q}] -> q
    end

    updated_queue = queue ++ [url]
    ETS.update(guild_id, updated_queue)
  end

  def play_next(guild_id) do
    queue = ETS.get(guild_id) |> case do
      [] -> []
      [{_key, q}] -> q
    end

    case queue do
      [] ->
        :ok

      [next_url | rest_of_queue] ->
        {_s, v_title} = Exyt.get_title(next_url)
        {_s, v_thumb} = Exyt.get_thumbnail(next_url)
        {_s, v_duration} = Exyt.get_duration(next_url)

        Utilities.play_when_ready(guild_id, next_url, :ytdl)

        embed = %Nostrum.Struct.Embed{
          thumbnail: %Nostrum.Struct.Embed.Thumbnail {
            url: v_thumb,
            height: 1200,
            width: 800
          }
        }
        |> put_color("16734313")
        |> put_title("Now Playing")
        |> put_field("Title", v_title)
        |> put_field("Duration", v_duration)

        ETS.update(guild_id, rest_of_queue)

        [
          embeds: [embed]
        ]
    end
  end
end
