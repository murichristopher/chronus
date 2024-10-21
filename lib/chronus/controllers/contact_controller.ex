defmodule Chronus.ContactController do
  import Plug.Conn
  alias Jason

  @contacts_base_url "http://localhost:5678/contacts"

  def index(conn, params) do
    req =
      Req.Request.new(method: :get, url: contacts_request_url(params))
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
        |> send_resp(500, Jason.encode!(%{error: "Failed to fetch contacts"}))
    end
  end

  defp contacts_request_url(%{"limit" => limit} = _params) do
    @contacts_base_url <> "?limit=#{limit}"
  end

  defp contacts_request_url(_params) do
    @contacts_base_url
  end
end
