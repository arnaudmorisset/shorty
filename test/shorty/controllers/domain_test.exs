defmodule Shorty.Controllers.DomainTest do
  use ExUnit.Case
  use Plug.Test

  @mimetype "application/json"
  @options Shorty.Router.init([])

  test "create: returns a JSON payload describing the created domain" do
    params = %{url: "https://fake.domain.locale/1234567890qwertyuiop"}

    assert domains_before = Shorty.Queries.Domain.by_original_url(params.url)

    conn =
      :post
      |> conn("/domains", Jason.encode!(params))
      |> put_req_header("content-type", @mimetype)
      |> Shorty.Router.call(@options)

    assert conn.status == 200

    assert {:ok, body} = Jason.decode(conn.resp_body)

    assert body["short_tag"]
    assert body["original_url"] == params.url
    assert body["shorten_url"] == "http://localhost:8080/#{body["short_tag"]}"

    assert domains_after = Shorty.Queries.Domain.by_original_url(params.url)
    assert length(domains_after) > length(domains_before)
  end

  test "create: returns a bad request error when the url is missing from the payload" do
    conn =
      :post
      |> conn("/domains", Jason.encode!(%{}))
      |> put_req_header("content-type", @mimetype)
      |> Shorty.Router.call(@options)

    assert conn.status == 400

    assert {:ok, body} = Jason.decode(conn.resp_body)

    assert body["error"] == "invalid_request"
    assert body["message"] == "The URL is missing"
  end
end
