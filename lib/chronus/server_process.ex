defmodule Chronus.ServerProcess do
  alias Chronus.ListScheduledMessages

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def put(value) do
    GenServer.cast(__MODULE__, {:put, value})
  end

  def get() do
    GenServer.call(__MODULE__, {:get})
  end

  def init(_) do
    {:ok, ListScheduledMessages.new()}
  end

  def handle_cast({:put, entry}, state) do
    list = ListScheduledMessages.add_entry(state, entry)

    json_entry = %{
      text: entry.body,
      to: entry.to
    }

    Chronus.Scheduler.put(json_entry, entry.send_at)

    {:noreply, list}
  end

  def handle_call({:get}, _, state) do
    {:reply, state, state}
  end
end
