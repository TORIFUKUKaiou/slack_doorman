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
      |> reply()

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

  def handle_command(
        %{
          "command" => "/broadcast",
          "text" => text,
          "user_id" => user_id,
          "channel_id" => channel_id
        } = params
      ) do
    IO.inspect(params)

    {parsed, args, _invalid} =
      String.split(text, " ")
      |> OptionParser.parse(strict: [channel: :keep], aliases: [c: :channel])
      |> IO.inspect()

    user = SlackDoorman.Users.get_user_by(user_id)
    msg = Enum.join(args, " ")

    Keyword.get_values(parsed, :channel)
    |> Enum.reduce(MapSet.new([channel_id]), fn channel_name, map_set ->
      channel_id =
        if String.starts_with?(channel_name, "<#") do
          String.slice(channel_name, 2..-3)
        else
          SlackDoorman.Channels.get_channel_by(channel_name)
        end

      if channel_id do
        MapSet.put(map_set, channel_id)
      else
        map_set
      end
    end)
    |> Enum.each(fn channel_id ->
      say(channel_id, msg, user.display_name, user.image)
    end)
  end

  def handle_command(params) do
    Logger.info("no handle")
    Logger.info(params)
    IO.inspect(params)
  end

  defp reply("ping"), do: "pong :robot_face:"

  defp reply(text), do: "#{text} (to parrot :parrot:)"

  defp say(
         channel,
         text,
         username \\ "awesome-bot",
         icon_url \\ "https://ca.slack-edge.com/TL799TXED-UL27SRN3V-ffb245030052-512"
       ) do
    %{
      channel: channel,
      text: text,
      link_names: true,
      username: username,
      icon_url: icon_url
    }
    |> Jason.encode!()
    |> SlackDoorman.Slack.Api.post_message()
  end
end
