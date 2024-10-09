defmodule Chronus.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Bandit, plug: Chronus.MyPlug, port: 3000},
      Chronus.MessageServer,
      Chronus.Scheduler,
      {Chronus.ServerProcess, []}
    ]

    opts = [strategy: :one_for_one, name: Chronus.Supervisor]
    {:ok, _pid} = Supervisor.start_link(children, opts)

    schedule_initial_tasks()

    {:ok, _pid}
  end

  defp schedule_initial_tasks do
    entry1 =
      Chronus.ScheduledMessage.new(%{
        body: "03:20!!!",
        send_at: "2024-10-09T04:23:00Z",
        from: "user_8345943559494395495",
        to: "chat_234982347348734748748"
      })

    Chronus.ServerProcess.put(entry1)
  end
end
