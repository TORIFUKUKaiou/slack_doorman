defmodule SlackDoorman.Handler do
  require Logger

  # https://api.slack.com/events/member_joined_channel
  def handle_event(
        %{
          "event" => %{"channel" => channel, "type" => "member_joined_channel", "user" => user},
          "type" => "event_callback"
        } = params
      ) do
    Logger.info("member_joined_channel")
    Logger.info(params)

    say(
      channel,
      "<@#{user}> Welcome! We are the alchemists, my friends!\n(https://github.com/TORIFUKUKaiou/slack_doorman)"
    )
  end

  # https://api.slack.com/events/member_left_channel
  def handle_event(
        %{
          "event" => %{"channel" => channel, "type" => "member_left_channel", "user" => user},
          "type" => "event_callback"
        } = params
      ) do
    Logger.info("member_left_channel")
    Logger.info(params)

    say(
      channel,
      "<@#{user}> left :sob:"
    )
  end

  # https://api.slack.com/events/app_mention
  def handle_event(
        %{
          "event" => %{
            "channel" => channel,
            "type" => "app_mention",
            "user" => user,
            "text" => text
          },
          "authorizations" => [%{"user_id" => bot_user_id}],
          "type" => "event_callback"
        } = params
      ) do
    Logger.info("app_mention")
    Logger.info(params)

    text =
      String.replace(text, "<@#{bot_user_id}>", "")
      |> String.trim()
      |> Kernel.<>("(to parrot :parrot:)")

    say(
      channel,
      "<@#{user}> #{text}"
    )
  end

  def handle_event(params) do
    Logger.info("no handle")
    Logger.info(params)
    IO.inspect(params)
  end

  defp say(channel, text) do
    %{
      channel: channel,
      text: text,
      link_names: true,
      username: "awesome-bot",
      icon_url: "https://ca.slack-edge.com/TL799TXED-UL27SRN3V-ffb245030052-512"
    }
    |> Jason.encode!()
    |> SlackDoorman.Slack.Api.post_message()
  end
end
