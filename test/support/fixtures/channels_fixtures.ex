defmodule SlackDoorman.ChannelsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SlackDoorman.Channels` context.
  """

  @doc """
  Generate a unique channel name.
  """
  def unique_channel_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique channel slack_id.
  """
  def unique_channel_slack_id, do: "some slack_id#{System.unique_integer([:positive])}"

  @doc """
  Generate a channel.
  """
  def channel_fixture(attrs \\ %{}) do
    {:ok, channel} =
      attrs
      |> Enum.into(%{
        name: unique_channel_name(),
        slack_id: unique_channel_slack_id()
      })
      |> SlackDoorman.Channels.create_channel()

    channel
  end
end
