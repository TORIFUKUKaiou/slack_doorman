defmodule SlackDoorman.Slack.Api do
  def post_message(json) do
    # https://api.slack.com/methods/chat.postMessage
    url = "https://slack.com/api/chat.postMessage"

    headers = [
      "Content-type": "application/json",
      Authorization: "Bearer #{slack_bot_token()}"
    ]

    {:ok, _response} = HTTPoison.post(url, json, headers)
  end

  def conversations_list(cursor) do
    # https://api.slack.com/methods/conversations.list
    url = "https://slack.com/api/conversations.list?limit=1000&cursor=#{cursor}"

    headers = [
      "Content-type": "application/json",
      Authorization: "Bearer #{slack_bot_token()}"
    ]

    {:ok, response} = HTTPoison.get(url, headers)
    response
  end

  def users_list(cursor \\ nil) do
    # https://api.slack.com/methods/users.list
    url = "https://slack.com/api/users.list?limit=1000&cursor=#{cursor}"

    headers = [
      "Content-type": "application/json",
      Authorization: "Bearer #{slack_bot_token()}"
    ]

    {:ok, response} = HTTPoison.get(url, headers)
    response
  end

  def all_conversations_list() do
    do_all_conversations_list(nil, [])
  end

  def all_users_list() do
    do_all_users_list(nil, [])
  end

  defp do_all_conversations_list("", channels) do
    channels
  end

  defp do_all_conversations_list(next_cursor, got_channels) do
    {:ok,
     %{
       "ok" => true,
       "channels" => channels,
       "response_metadata" => %{"next_cursor" => new_next_cursor}
     }} =
      conversations_list(next_cursor)
      |> Map.get(:body)
      |> Jason.decode()

    new_got_channels =
      channels
      |> Enum.filter(& &1["is_channel"])
      |> Kernel.++(got_channels)

    do_all_conversations_list(new_next_cursor, new_got_channels)
  end

  defp do_all_users_list("", users) do
    users
  end

  defp do_all_users_list(next_cursor, got_users) do
    {:ok,
     %{
       "ok" => true,
       "members" => members,
       "response_metadata" => %{"next_cursor" => new_next_cursor}
     }} =
      users_list(next_cursor)
      |> Map.get(:body)
      |> Jason.decode()

    new_got_users =
      members
      |> Enum.reject(& &1["is_bot"])
      |> Kernel.++(got_users)

    do_all_users_list(new_next_cursor, new_got_users)
  end

  defp slack_bot_token do
    System.get_env("SLACK_BOT_TOKEN")
  end
end
