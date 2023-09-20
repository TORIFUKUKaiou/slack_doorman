# SlackDoorman

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Run(production)

```bash
cp .env.sample .env
# edit
vi .env
docker compose build
docker compose up -d
docker compose exec -it app bin/migrate
docker compose exec -it app bin/slack_doorman rpc "SlackDoorman.Slack.update_channels()"
docker compose exec -it app bin/slack_doorman rpc "SlackDoorman.Slack.update_users()"
```

## Run(Local)

```bash
export SLACK_SIGNING_SECRET="xxxxxxx"
export SLACK_BOT_TOKEN="xoxb-xxxxxxxx"
docker run -d --rm -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres postgres
mix setup
mix phx.server
```
