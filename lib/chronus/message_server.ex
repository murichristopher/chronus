defmodule Chronus.MessageServer do
  use GenServer
  require Logger

  def start() do
    GenServer.start_link(__MODULE__, nil, name: :message_server)
  end

  def send_message(message) do
    GenServer.cast(:message_server, {:receive_message, message})
  end

  def init(_) do
    Logger.info("MessageServer started and is ready to receive messages.")
    {:ok, []}
  end

  def handle_info({:receive_message, message}, state) do
    Logger.debug("Received message: #{inspect(message)}. Processing now...")
    process_message(message)
    {:noreply, state}
  end

  defp process_message(message) do
    Logger.info("Processing message: #{inspect(message)}")

    Chronus.AMQPService.publish_message("hello", message)
  end
end
