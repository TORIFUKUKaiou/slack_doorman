defmodule SlackDoorman.Worker do
  use GenServer

  @one_hour 60 * 60 * 1000

  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_state) do
    Process.send_after(__MODULE__, :hourly, 1)
    {:ok, %{}}
  end

  def handle_info(:hourly, %{}) do
    Process.send_after(__MODULE__, :hourly, @one_hour)

    spawn(fn -> SlackDoorman.Slack.update_channels() end)
    spawn(fn -> SlackDoorman.Slack.update_users() end)

    {:noreply, %{}}
  end
end
