defmodule Chronus.MyPlug do
  use Plug.Router

  plug(Plug.Logger)
  plug(MetricsExporter)
  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)
  plug(:match)
  plug(:dispatch)

  post "/messages" do
    Chronus.MessageController.create(conn, conn.params)
  end

  get "/messages" do
    Chronus.MessageController.index(conn, conn.params)
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
