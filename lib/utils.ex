defmodule URLParser.Utils do
  @moduledoc """
  Helper module to keep utility functions.
  See functions docs for more details
  """

  @spec parse_and_validate_url(binary | URI.t()) :: {:error, :invalid_url} | {:ok, URI.t()}
  @doc """
  Parse the given URL and validate if provided url is valid or not.

  if valid it returns uri struct else error as invalid url

  Examples:
      iex> URLParser.Utils.parse_and_validate_url("http://httparrot.herokuapp.com")
      %URI{
        authority: "httparrot.herokuapp.com",
        fragment: nil,
        host: "httparrot.herokuapp.com",
        path: nil,
        port: 80,
        query: nil,
        scheme: "http",
        userinfo: nil
      }

      iex> URLParser.Utils.parse_and_validate_url("some-dummy-url-to-validate.te")
      {:error, :invalid_url}

  """
  def parse_and_validate_url(url) do
    uri = URI.parse(url)

    if uri.scheme != nil && uri.host =~ ".", do: {:ok, uri}, else: {:error, :invalid_url}
  end

  @spec parse_data_to_get_valid_urls(
          binary,
          binary | [Floki.Selector.t()] | Floki.Selector.t(),
          any,
          any
        ) :: list
  @doc """
  Parsing the received data after fetching from URLs and filtering  and returning the valid one

  in case of invalid URLs we are just ingnoring
  """
  def parse_data_to_get_valid_urls(response_data, attr, tag, host) do
    response_data
    |> Floki.parse_document!()
    |> Floki.find(attr)
    |> Enum.map(fn {^attr, tags, _} ->
      {^tag, url} = Enum.find(tags, &(&1 |> elem(0) == tag))

      validate_and_sanitize_url(url, host)
    end)
  end

  defp validate_and_sanitize_url(url, host) do
    case parse_and_validate_url(url) do
      {:ok, %URI{}} -> url
      {:error, :invalid_url} -> Path.join(host, url)
    end
  end
end
