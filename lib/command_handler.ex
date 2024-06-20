defmodule Musique.Core.EventConsumer do
  use Nostrum.Consumer
  require Logger

  alias Musique.Core.AppCommandLoader
  alias Nosedrum.Storage.Dispatcher

  # Because we're shifting almost all the work of handling commands off to Nosedrum
  # we don't need to do anything more than load our commands, then pass any interaction_create
  # messages off to Nosedrum.Storage.Dispatcher

  # On bot ready
  def handle_event({:READY, %Nostrum.Struct.Event.Ready{} = event, ws_state}) do
    AppCommandLoader.load_all()
  end

  # On interaction create
  def handle_event({:INTERACTION_CREATE, intr, _}), do:
    Dispatcher.handle_interaction(intr)

  def handle_event({:VOICE_READY, payload, _}) do
    Logger.debug(inspect(payload))
    Process.sleep(2000)
    Logger.info(inspect(Nostrum.Voice.get_voice(payload.guild_id)))
  end

  def handle_event({:VOICE_SPEAKING_UPDATE, payload, _}) do
    Logger.debug(inspect(payload))
  end

  def handle_event({:VOICE_STATE_UPDATE, payload, _}) do
    Logger.debug(inspect(payload))
  end

  def handle_event({:VOICE_SERVER_UPDATE, payload, _}) do
    Logger.debug(inspect(payload))
  end

  def handle_event(_), do: :noop
end
