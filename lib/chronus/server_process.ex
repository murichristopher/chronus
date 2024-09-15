defmodule Chronus.ServerProcess do
  alias Chronus.ListScheduledMessages
  alias Chronus.ServerProcess

  use GenServer

  def start do
    GenServer.start(ServerProcess, nil)
  end

  def put(pid, value) do
    GenServer.cast(pid, {:put, value})
  end

  def get(pid) do
    GenServer.call(pid, {:get})
  end

  def init(_) do
    {:ok, ListScheduledMessages.new()}
  end

  def handle_cast({:put, entry}, state) do
    list = ListScheduledMessages.add_entry(state, entry)

    json_entry = %{
      text: entry.body
    }

    Chronus.Scheduler.put(json_entry, entry.send_at)

    {:noreply, list}
  end

  def handle_call({:get}, _, state) do
    {:reply, state, state}
  end
end
