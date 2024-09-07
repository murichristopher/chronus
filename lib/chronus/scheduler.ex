defmodule Chronus.Scheduler do
  use GenServer

  def start do
    GenServer.start_link(__MODULE__, nil, name: :scheduler)
  end

  def put(entry, from_pid) do
    GenServer.cast(:scheduler, {:put, entry, from_pid})
  end

  def handle_cast({:put, entry, _from_pid}, _state) do
    Process.send_after(:message_server, {:receive_message, entry.body}, 3000)
    {:noreply, :ok}
  end

  def init(_) do
    {:ok, nil}
  end
end
