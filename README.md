# Shorty

A dead-simple web API to shorten URL, built with Elixir.

## Motivation

> This project aim to be an educational repository.

My main motivation was to show how we can build a web API in Elixir, without Phoenix.
I'll probably continue to use this project as a sandbox to play with stuff like error monitoring, tracing and metrics.
Maybe I will also create a series of blogpost to explain how to build this project step by step.

## Tech/framework used

- `ecto_sql` => as ORM
- `postgrex` => as PostgreSQL driver
- `plug_cowboy` => as web server
- `jason` => as JSON encode/decoder

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
