defmodule Chronus.Scheduler do
  use GenServer

  def start do
    GenServer.start_link(__MODULE__, nil, name: :scheduler)
  end

  def put(entry, send_at) do
    GenServer.cast(:scheduler, {:put, entry, send_at})
  end

  def handle_cast({:put, entry, send_at}, _state) do
    send_message(entry, send_at)

    {:noreply, :ok}
  end

  def init(_) do
    {:ok, nil}
  end

  defp send_message(entry, send_at) do
    {:ok, datetime, _} = DateTime.from_iso8601(send_at)
    diff = DateTime.utc_now() |> DateTime.diff(datetime)
    send_at = diff * -1 * 1000
    IO.puts("[SENDIN IN]: #{send_at}")

    Process.send_after(:message_server, {:receive_message, Jason.encode!(entry)}, send_at)
  end
end
