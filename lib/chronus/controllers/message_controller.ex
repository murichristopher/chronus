defmodule Chronus.MessageController do
  import Plug.Conn
  alias Jason

  def create(conn, %{"body" => body, "send_at" => send_at, "to" => to}) do
    entry =
      Chronus.ScheduledMessage.new(%{
        body: body,
        send_at: send_at,
        from: "...",
        to: to
      })

    Chronus.ServerProcess.put(entry)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(204, "OK")
  end
end
