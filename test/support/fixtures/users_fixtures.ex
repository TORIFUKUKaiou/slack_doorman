defmodule SlackDoorman.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SlackDoorman.Users` context.
  """

  @doc """
  Generate a unique user slack_id.
  """
  def unique_user_slack_id, do: "some slack_id#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        image: "some image",
        display_name: "some display_name",
        slack_id: unique_user_slack_id()
      })
      |> SlackDoorman.Users.create_user()

    user
  end
end
