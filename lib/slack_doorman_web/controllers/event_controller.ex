defmodule SlackDoormanWeb.EventController do
  use SlackDoormanWeb, :controller
  require Logger

  def create(
        conn,
        %{"challenge" => challenge, "token" => _token, "type" => "url_verification"} = params
      ) do
    Logger.info(conn)
    Logger.info(params)

    if SlackDoorman.Slack.validate_request(conn) do
      conn
      |> put_status(:ok)
      |> render("challenge.json", challenge: challenge)
    end
  end

  def create(conn, params) do
    Logger.info(conn)
    Logger.info(params)

    if SlackDoorman.Slack.validate_request(conn), do: do_something(params)

    ok(conn)
  end

  defp ok(conn) do
    conn
    |> put_status(:ok)
    |> render("ok.json", ok: :ok)
  end

  defp do_something(params) do
    Logger.info("do_something")
    spawn(fn -> SlackDoorman.Handler.handle_event(params) end)
  end
end
