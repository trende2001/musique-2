defmodule Musique.Core.ETS do
  @moduledoc """
  Module for manipulating memory in an ETS table
  """

  # We want to keep ETS alive
  use Agent

  def start_link(_something) do
    Agent.start_link(fn -> :ets.new(:musique, [:set, :private, :named_table]) end,
      name: __MODULE__
    )
  end

  def get(type) do
    Agent.get(__MODULE__, fn _state ->
      :ets.lookup(:musique, type)
    end)
  end

  def update(type) do
    Agent.update(__MODULE__, fn _state ->
      :ets.insert(:musique, type)
    end)
  end

  def remove(type) do
    Agent.update(__MODULE__, fn _state ->
      :ets.delete(:musique, type)
    end)
  end

  def remove_all() do
    Agent.update(__MODULE__, fn _state ->
      :ets.delete_all_objects(:musique)
    end)
  end
end
