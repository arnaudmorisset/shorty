defmodule Shorty.Controllers.DomainTest do
  use ExUnit.Case
  use Shorty.RepoCase
  use Plug.Test

  @mimetype "application/json"
  @options Shorty.Router.init([])

  test "create: returns a JSON payload describing the created domain" do
    params = %{url: "https://fake.domain.local/1234567890qwertyuiop"}

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

  test "create: respond with the existing domain when original url is already used" do
    params = %{url: "https://fake.domain.local/1234567890qwertyuiop"}

    {:ok, domain} =
      %{url: params.url, short_tag: "1234"}
      |> Shorty.Models.Domain.changeset_creation()
      |> Shorty.Commands.Domain.create()

    conn =
      :post
      |> conn("/domains", Jason.encode!(params))
      |> put_req_header("content-type", @mimetype)
      |> Shorty.Router.call(@options)

    assert conn.status == 200

    assert {:ok, body} = Jason.decode(conn.resp_body)

    assert body["original_url"] == domain.url
    assert body["short_tag"] == domain.short_tag
    assert body["shorten_url"] == "http://localhost:8080/#{body["short_tag"]}"
  end

  test "create: returns an unprocessable_entity when the url is missing from the payload" do
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

  test "create: returns an unprocessable_entity when the url isn't valid" do
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

  test "show: redirect the user when everything is fine" do
    {:ok, domain} =
      %{
        url: "https://fake.domain.local/qwertyuiop1234567890asdfghjklzxcvbnm",
        short_tag: "1234"
      }
      |> Shorty.Models.Domain.changeset_creation()
      |> Shorty.Commands.Domain.create()

    conn =
      :get
      |> conn("/#{domain.short_tag}", "")
      |> Shorty.Router.call(@options)

    assert conn.status == 301
  end

  test "show: returns 404 when the original URL cannot be found" do
    conn =
      :get
      |> conn("/nonexistingtag", "")
      |> Shorty.Router.call(@options)

    assert conn.status == 404

    assert {:ok, body} = Jason.decode(conn.resp_body)

    assert body["error"] == "not_found"
    assert body["message"] == "The original URL cannot be found"
  end
end
