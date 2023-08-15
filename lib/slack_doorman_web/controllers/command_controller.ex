defmodule SlackDoormanWeb.CommandController do
  use SlackDoormanWeb, :controller
  require Logger

  def create(conn, params) do
    Logger.info(conn)
    Logger.info(params)
    IO.inspect(params)

    if SlackDoorman.Slack.validate_request(conn) do
      do_something(params)

      conn
      |> put_status(:ok)
      |> render(:create, ok: :ok)
    end
  end

  defp do_something(params) do
    Logger.info("do_something")
    spawn(fn -> SlackDoorman.Handler.handle_command(params) end)
  end
end
