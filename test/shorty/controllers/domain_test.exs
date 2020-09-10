defmodule Shorty.Controllers.DomainTest do
  use ExUnit.Case
  use Plug.Test

  @mimetype "application/json"
  @options Shorty.Router.init([])

  test "create: returns a JSON payload describing the created domain" do
    params = %{url: "https://fake.domain.locale/1234567890qwertyuiop"}

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

    assert {:ok, _} = Shorty.Queries.Domain.by_original_url(params.url)
  end

  test "create: returns a bad request error when the url is missing from the payload" do
    conn =
      :post
      |> conn("/domains", Jason.encode!(%{}))
      |> put_req_header("content-type", @mimetype)
      |> Shorty.Router.call(@options)

    assert conn.status == 422

    assert {:ok, body} = Jason.decode(conn.resp_body)

    assert body["error"] == "unprocessable_entity"
    assert body["message"] == "The URL is not valid"
  end

  test "create: returns a bad format when the url isn't valid" do
    params = %{url: "1234567890qwertyuiop"}

    conn =
      :post
      |> conn("/domains", Jason.encode!(params))
      |> put_req_header("content-type", @mimetype)
      |> Shorty.Router.call(@options)

    assert conn.status == 422

    assert {:ok, body} = Jason.decode(conn.resp_body)

    assert body["error"] == "unprocessable_entity"
    assert body["message"] == "The URL is not valid"
  end
end
