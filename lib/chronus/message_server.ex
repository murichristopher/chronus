defmodule Chronus.MessageServer do
  use GenServer

  def start() do
    GenServer.start_link(__MODULE__, nil, name: :message_server)
  end

  def send_message(message) do
    GenServer.cast(:message_server, {:receive_message, message})
  end

  def init(_) do
    IO.puts("MessageServer started...")
    {:ok, []}
  end

  def handle_info({:receive_message, message}, state) do
    process_message(message)
    {:noreply, state}
  end

  defp process_message(message) do
    IO.puts("Message Received: #{message}")
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Queue.declare(channel, "hello")
    AMQP.Basic.publish(channel, "", "hello", message)
    IO.puts(" [x] Sent '#{message}'")
    AMQP.Connection.close(connection)
  end
end
