defmodule Musique.Queue do
  @moduledoc """
  Handles queue tables per guild. Includes ways to manipulate and query things from the assigned table.
  """
  use Agent
  alias Musique.Utilities

  import Nostrum.Struct.Embed

  def child_spec(_) do
    %{id: __MODULE__, start: {__MODULE__, :start_link, []}}
  end

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(guild_id) do
    Agent.get(__MODULE__, fn state ->
      Map.get(state, guild_id)
    end)
  end

  def update(guild_id, queue) do
    Agent.update(__MODULE__, fn state ->
      Map.replace(state, guild_id, queue)
    end)
  end

  def add(guild_id, url) do
    queue = get(guild_id)

    case queue do
      nil ->
        update(guild_id, [url])

      _ ->
        update(guild_id, queue ++ [url])
    end
  end

  def play_next(guild_id) do
    queue = get(guild_id)

    case queue do
      nil ->
        :ok

      [next_url | rest_of_queue] ->
        {_s, v_title} = Exyt.get_title(next_url)
        {_s, v_thumb} = Exyt.get_thumbnail(next_url)
        {_s, v_duration} = Exyt.get_duration(next_url)

        Utilities.play_when_ready(guild_id, next_url, :ytdl)

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

        update(guild_id, rest_of_queue)

        [
          embeds: [embed]
        ]
    end
  end
end
