defmodule Chronus.ConnectController do
  import Plug.Conn
  alias Jason

  @connect_url "http://localhost:5678/instance_connect"

  def index(conn, _params) do
    req =
      Req.Request.new(method: :get, url: @connect_url)
      |> Req.Request.append_response_steps(
        decompress_body: &Req.Steps.decompress_body/1,
        decode_body: &Req.Steps.decode_body/1
      )

    with {_request, response = %Req.Response{status: 200}} <- Req.Request.run_request(req) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(response.body))
    else
      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(500, Jason.encode!(%{error: "Failed to connect"}))
    end
  end
end
