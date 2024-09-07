defmodule Chronus.ServerProcess do
  alias Chronus.ListScheduledMessages
  alias Chronus.ServerProcess

  use GenServer

  def start do
    GenServer.start(ServerProcess, nil)
  end

  def put(pid, value) do
    GenServer.cast(pid, {:put, value, self()})
  end

  def put_and_respond(pid, value) do
    GenServer.cast(pid, {:put_and_respond, value, self()})

    receive do
      {:response, response} -> response
    after
      5000 -> :timeout
    end
  end

  def get(pid) do
    GenServer.call(pid, {:get})
  end

  def init(_) do
    {:ok, ListScheduledMessages.new()}
  end

  def handle_cast({:put, entry, from_pid}, state) do
    list = ListScheduledMessages.add_entry(state, entry)

    Chronus.Scheduler.put(entry, from_pid)

    {:noreply, list}
  end

  def handle_call({:get}, _, state) do
    {:reply, state, state}
  end
end
