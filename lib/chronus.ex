defmodule Chronus.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Bandit, plug: Chronus.MyPlug, port: 3000},
      Chronus.MessageServer,
      Chronus.Scheduler,
      Chronus.CacheServer,
      {Chronus.ServerProcess, []}
    ]

    opts = [strategy: :one_for_one, name: Chronus.Supervisor]

    MetricsSetup.setup()

    Supervisor.start_link(children, opts)
  end

  # defp schedule_initial_tasks do
  #   now = DateTime.utc_now() |> DateTime.add(10, :second)

  #   scheduled_message =
  #     Chronus.ScheduledMessage.new(%{
  #       body: "03:20!!!",
  #       send_at: DateTime.to_iso8601(now),
  #       from: "user_8345943559494395495",
  #       to: "5511971485860"
  #     })

  #   Chronus.ServerProcess.put(scheduled_message)
  # end
end
