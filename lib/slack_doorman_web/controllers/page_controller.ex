defmodule SlackDoormanWeb.PageController do
  use SlackDoormanWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
