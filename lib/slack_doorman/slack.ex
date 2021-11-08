defmodule SlackDoorman.Slack do
  require Logger

  def validate_request(conn) do
    # https://api.slack.com/authentication/verifying-requests-from-slack
    Logger.info("validate_request")

    timestamp =
      conn.req_headers
      |> Enum.find(fn {key, _} -> key == "x-slack-request-timestamp" end)
      |> elem(1)
      |> tap(&Logger.info/1)
      |> String.to_integer()

    request_body = conn.assigns.raw_body |> Enum.at(0) |> tap(&Logger.info/1)

    slack_signature =
      conn.req_headers
      |> Enum.find(fn {key, _} -> key == "x-slack-signature" end)
      |> elem(1)
      |> tap(&Logger.info/1)

    validate_request(timestamp, request_body, slack_signature)
  end

  defp validate_request(timestamp, request_body, slack_signature) do
    DateTime.diff(DateTime.now!("Etc/UTC"), DateTime.from_unix!(timestamp))
    |> validate_request(timestamp, request_body, slack_signature)
  end

  defp validate_request(diff, _timestamp, _request_body, _slack_signature)
       when abs(diff) > 5 * 60 do
    false
  end

  defp validate_request(_diff, timestamp, request_body, slack_signature) do
    slack_signing_secret = System.get_env("SLACK_SIGNING_SECRET")

    sig_basestring = "v0:" <> Integer.to_string(timestamp) <> ":" <> request_body

    my_signature =
      :crypto.mac(:hmac, :sha256, slack_signing_secret, sig_basestring)
      |> Base.encode16()
      |> String.downcase()

    my_signature = "v0=" <> my_signature

    my_signature == slack_signature
  end
end
