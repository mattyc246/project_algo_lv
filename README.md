# ProjectAlgoLv

### Development

To start your Phoenix server:

  * Setup the project with `mix setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Minimum requirements

If using a .env file in development, export needs to be appended to the .env variables and before running of the server `source .env` command needs to be run.

Environment Variables:

```env
export AWS_ACCESS_KEY=""
export AWS_SECRET_KEY=""
export DYNAMODB_REGION=""
export DYNAMODB_TABLE=""
export STRIPE_PUBLISHABLE_KEY=""
export STRIPE_SECRET_KEY=""
```

### Dependencies

##### Assets

- Bootstrap
- Bootswatch
- chart.js
- chartkick
- font-awesome
- jquery
- popper.js
- highcharts
- @babel/polyfill (Async Await)
- @stripe/stripejs

##### Mix

```elixir
{:pbkdf2_elixir, "~> 1.2.1"},
{:ex_aws_dynamo, "~> 3.0"},
{:hackney, "~> 1.9"},
{:cors_plug, "~> 1.5"},
{:timex, "~> 3.6.2"},
{:stripity_stripe, "~> 2.8.0"}
```
---

### Happy Hacking!

---

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

### Production

---

Some minimal setup is required for deployment.

Deployment to heroku needs 2 buildpacks in order to deploy successfully.

```
heroku buildpacks:add hashnuke/elixir
```
```
heroku buildpacks:add https://github.com/gjaldon/heroku-buildpack-phoenix-static.git
```

The buildpack will use a predefined version of `elixir` and `erlang`, however, it is best to explicitly define which versions of `elixir` and `erlang` the application should use through an `elixir_buildpack.config` file.

```
# Elixir version
elixir_version=1.8.1

# Erlang version
# available versions https://github.com/HashNuke/heroku-buildpack-elixir-otp-builds/blob/master/otp-versions
erlang_version=21.2.5
```

Additionally, as static assets are being used it is also recommended to use a `phoenix_static_buildpack.config` file to be used in order to specify the node version to be used for the assets.

```
# Node version
node_version=10.20.1
```

Phoenix needs to be told to enforce SSL when being deployed to heroku so some changes are necessary in order for this to work correctly.

In the `config/prod.exs` file:

```elixir
# REPLACE
url: [host: "example.com", port: 80],

# WITH
http: [port: {:system, "PORT"}],
url: [scheme: "https", host: "yourappname.herokuapp.com", port: 443],
force_ssl: [rewrite_on: [:x_forwarded_proto]],
```

In the `config/prod.secret.exs` file:

```elixir
config :hello, Hello.Repo,
  ssl: true, # Uncomment this
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
```

Also for the sockets, some configuration is required to help with running on Heroku.

In the `lib/project_algo_lv_web/endpoint.ex` file:

```elixir
defmodule ProjectAlgoLvWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :hello

  socket "/socket", ProjectAlgoLvWeb.UserSocket,
    websocket: [timeout: 45_000],
    longpoll: false

  ...
end
```

Finally for the DB pool size, as heroku limits connections to 20 connections:

```
heroku config:set POOL_SIZE=18
```

### Env Variables

There are minimum environment variables required in order for the application to run correctly.

First generate a secret key by running `mix phx.gen.secret`

```env
SECRET_KEY_BASE="<generated_secret_key>"
AWS_ACCESS_KEY=""
AWS_SECRET_KEY=""
DYNAMODB_REGION=""
DYNAMODB_TABLE=""
STRIPE_PUBLISHABLE_KEY=""
STRIPE_SECRET_KEY=""
```

### User Flow

As this is a members only platform, there is no direct way to register for an account. If it is the first time running the application in production you will need to use the interactive elixir shell to generate a new account. The steps to do this are below:

1. First run the shell in heroku

```
heroku run "POOL_SIZE=2 iex -S mix"
```
*Note: Pool size is limited to reduce excess connections being opened.*

2. Alias the Accounts context in order to create a user

```
alias ProjectAlgoLv.Accounts
```

3. Use the create user function with the required fields to create a new user

```
Accounts.create_user(%{
    name: "",
    email: "",
    password: "",
    password_confirmation: ""
})
```

Once an account has been generated you will need to go into the DB to add a role to the user for `admin`. This can be done through a GUI for postgres DB. The user roles is an arrary field and contains an array of the roles the user has.

From here, members can then be invited through the invitation that was generated with the account. By default the number of uses an invite can have is only 5 but this can be manually increased through the DB, there is no restriction for admin to do this.

For regular users the flow is fairly straight forward:

1. Give them an invite link.

```
https://<base_url>/invite/<invite_code>
```

2. User will register for a new account and on successful registration the invitation number of invites remaining will automatically be reduced.

3. User can then sign in with the credentials they have just created.

4. User will be prompted to make payment for the membership. This will be done through Stripe payment gateway. Once payment is successful the user will then have a membership generated with access for **1 year** from the creation date and they can proceed to the dashboard.

### Sending Algorithm Data

The application is decoupled from being tied to any brokerage platform to ease the integration with different brokers.

The application uses DynamoDB to store the algorithm data and requires a set minumum amount of data being passed to it. In the case the data is not supplied by the brokerage, simply provide a 0 value to avoid any errors.

The data is sent to the endpoint:

```
"https://<base_url>/api/v1/strategy/"
```

Below is an example in Python of the data that needs to be sent. Everything is handled in USD so the respective amounts must be converted if the platform is not dealing with assets in USD.

```python
margin_usd = round(Decimal(balance['marginBalance'] / 100000000 * ticker['last']), 2)
wallet_usd = round(Decimal(balance['walletBalance'] / 100000000 * ticker['last']), 2)
realised_pnl_usd = round(Decimal(position['realisedPnl'] / 100000000 * ticker['last']), 2)

obj = {
    "data" : {
        'strategy_access_token': 'OsoDiJtKUMqSZkq5GfjpssYLwkPtm+wejqkO+Dq4IL',
        'last_price': Decimal(str(ticker['last'])),
        'margin_balance': margin_usd,
        'wallet_balance': wallet_usd,
        'realised_pnl': realised_pnl_usd,
        'positions': position['currentQty'],
        'symbol': position['symbol'],
        'average_entry_price': Decimal(str(position['avgEntryPrice']))
    }
}
url = "https://projectalgo.herokuapp.com/api/v1/strategy/"

result = requests.post(url, json=obj)
```

The strategy access token needs to be obtained from the application.

1. First an account must be created in order to tie the strategy to a brokerage account, this just simply helps to avoid strategies sharing accounts from having their balance applied to the combined wallet balance.

2. Create a strategy and once created you can then obtain an access token that can be set in the algorithm.
