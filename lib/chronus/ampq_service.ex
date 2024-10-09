defmodule Chronus.AMQPService do
  require Logger

  # Modify the connection options to include RabbitMQ credentials
  def publish_message(queue, message) do
    connection_options = [
      username: "user",
      password: "password",
      host: "localhost"
    ]

    with {:ok, connection} <- AMQP.Connection.open(connection_options),
         {:ok, channel} <- AMQP.Channel.open(connection),
         :ok <- declare_queue(channel, queue),
         :ok <- AMQP.Basic.publish(channel, "", queue, message) do
      Logger.info("Message '#{message}' published to queue '#{queue}'.")
      AMQP.Connection.close(connection)
      Logger.info("AMQP connection closed successfully.")
    else
      {:error, reason} -> Logger.error("Failed to publish message: #{inspect(reason)}")
    end
  end

  defp declare_queue(channel, queue) do
    AMQP.Queue.declare(channel, queue)
    Logger.info("Queue '#{queue}' declared successfully.")
    :ok
  end
end
