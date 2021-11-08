defmodule SlackDoormanWeb.EventView do
  use SlackDoormanWeb, :view

  def render("challenge.json", %{challenge: challenge}) do
    %{challenge: challenge}
  end

  def render("ok.json", %{ok: :ok}) do
    %{}
  end
end
