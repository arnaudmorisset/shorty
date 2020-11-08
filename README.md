# Shorty

![Test and Deploy](https://github.com/arnaudmorisset/shorty/workflows/Test%20and%20Deploy/badge.svg?branch=master&event=push)

---

Shorty is a web API for shortening URLs.

## Installation

```bash
# 1. Clone the repository.
git clone git@github.com:arnaudmorisset/shorty.git && cd shorty

# 2. Fetch dependencies.
mix deps.get

# 3. Create database and run migrations.
# ⚠️ PostgreSQL is required, if you are a Docker user, just use `docker-compose up`.
mix ecto.setup

# 4. Start the application
iex -S mix
```

> If you have Docker on your machine, you can start a PostgeSQL instance using `docker-compose up`.

After that, everything should be fine and you can reach the application at `http://localhost:4000`.

## Usage

The endpoint `POST /domains` will allow you to shorten a URL.
You will need to send this URL as a JSON params in request's body.

```bash
# You can try the following with your favorite HTTP client.
curl -XPOST "http://localhost:4000/domains" -d '{"url": "https://a.too.long.url/1234qwerty4567uiopasdfghjklzxcvbnm"}' -H "Content-type: application/json"
```

This endpoint should respond with a JSON payload like the following:

```json
{
  "original_url":"https://a.too.long.url/1234qwerty4567uiopasdfghjklzxcvbnm",
  "short_tag":"HcO3mkfcdXaagQEI",
  "shorten_url":"http://localhost:4000/HcO3mkfcdXaagQEI"
}
```

As this endpoint send back JSON, you can easily parse it using a tool like [jq](https://stedolan.github.io/jq/).
For example, I added the following function in my `.zshrc`:

```bash
shorty() {
  curl -XPOST "http://localhost:4000/domains" -d '{"url": "'"$1"'"}' -H "Content-type: application/json" | jq '.shorten_url'
}
```

## License

"THE BEER-WARE LICENSE" (Revision 42):

<arnaudmorisset@protonmail.com> wrote this file.  As long as you retain this notice you
can do whatever you want with this stuff. If we meet some day, and you think
this stuff is worth it, you can buy me a beer in return.
