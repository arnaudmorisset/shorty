# Shorty

A dead-simple web API to shorten URL, built with Elixir.

## Motivation

> This project aims to be an educational repository.

My main motivation was to show how we can build a web API in Elixir, without Phoenix.
I'll probably continue to use this project as a sandbox to play with stuff like error monitoring, tracing and metrics.
Maybe I will also create a series of blogpost to explain how to build this project step by step.

## Tech/framework used

- `ecto_sql` => as an ORM
- `postgrex` => as a PostgreSQL driver
- `plug_cowboy` => as a web server
- `jason` => as a JSON encode/decoder

## Usage

Once your application is deployed in a production/staging environment, you can use it like that:

```bash
# Shorten a URL by calling the POST /domains endpoint
curl -XPOST "http://your.domain.name/domains" -d '{"url": "https://a.too.long.url/1234qwerty4567uiopasdfghjklzxcvbnm"}' -H "Content-type: application/json"

# Here's what a response looks like
{
  "original_url":"https://a.too.long.url/1234qwerty4567uiopasdfghjklzxcvbnm",
  "short_tag":"HcO3mkfcdXaagQEI",
  "shorten_url":"http://your.domain.name/HcO3mkfcdXaagQEI"
}
```

The ideal usage is to create an alias using `cURL` and `jq` as follow:

```bash
alias shorty=curl -XPOST "http://your.domain.name/domains" -d '{"url": "${$1}"}' -H "Content-type: application/json" | jq '.shorten_url'
```

## Installation

```bash
# 1. Clone the repository
git clone git@github.com:arnaudmorisset/shorty.git

# 2. Start third-party services (only PostgreSQL for now)
docker-compose up

# 3. Create database and run migrations
mix ecto.setup
```

After that, everything should be fine and you can reach the application at `http://localhost:4000`.

## Deployment

I use Gigalixir for this kind of project.
They have a nice documentation.
Feel free to use what you want. 🤷‍♂️

## License

"THE BEER-WARE LICENSE" (Revision 42):

<arnaudmorisset@protonmail.com> wrote this file.  As long as you retain this notice you
can do whatever you want with this stuff. If we meet some day, and you think
this stuff is worth it, you can buy me a beer in return.
