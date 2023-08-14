defmodule SlackDoormanWeb.EventJSON do
  def create(%{challenge: challenge}) do
    %{challenge: challenge}
  end

  def create(%{ok: :ok}) do
    %{}
  end
end
