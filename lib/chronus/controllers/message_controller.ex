defmodule Chronus.MessageController do
  import Plug.Conn
  alias Jason

  def index(conn, _params) do
    messages = get_messages()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(messages))
  end

  def create(conn, params) do
    with {:ok, _params} <- validate_params(params),
         {:ok, _entry} <- create_message(params) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(204, "OK")
    else
      {:error, message} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          422,
          Jason.encode!(%{
            error: message
          })
        )
    end
  end

  defp get_messages() do
    case Chronus.CacheServer.get() do
      nil -> []
      messages -> messages
    end
  end

  defp create_message(%{"send_at" => send_at, "body" => body, "to" => to}) do
    entry =
      Chronus.ScheduledMessage.new(%{
        body: body,
        send_at: send_at,
        from: "...",
        to: to
      })

    {:ok, Chronus.ServerProcess.put(entry)}
  end

  defp validate_params(%{"send_at" => send_at} = params) do
    {:ok, date, _offset} = DateTime.from_iso8601(send_at)

    case DateTime.diff(date, DateTime.utc_now()) < 0 do
      false -> {:ok, params}
      true -> {:error, "The `send_at` param cannot be in the past."}
    end
  end
end
