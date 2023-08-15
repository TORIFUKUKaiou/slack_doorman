defmodule SlackDoormanWeb.CommandController do
  use SlackDoormanWeb, :controller
  require Logger

  def create(conn, params) do
    Logger.info(conn)
    Logger.info(params)
    IO.inspect(params)

    if SlackDoorman.Slack.validate_request(conn) do
      conn
      |> put_status(:ok)
      |> render(:create, ok: :ok)
    end
  end
end
