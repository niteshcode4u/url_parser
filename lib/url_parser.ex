defmodule URLParser do
  @moduledoc """
  Module to fetch data from given url, parse it, and format into links & assets

  See function docs `h URLParser.fetch/1` to understand working flow.
  """

  alias URLParser.Behaviours.Http, as: HttpAdapter
  alias URLParser.Utils

  @spec fetch(binary | URI.t()) :: {:error, any} | {:ok, %{assets: list, links: list}}
  @doc """
  Fetch data based on provided URL and return an object with keys {`assets` & `links`}.

  PS: Currently, return expected results for valid URLs which return HTML page as response
  containing `<img>` & `<a>` tags. However, enhancement can be done to handle different types of url.

  Examples:
      iex> URLParser.fetch("http://httparrot.herokuapp.com")
      {:ok,
        %{
          assets: ["https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png"],
          links: [
            "http://github.com/edgurgel/httparrot",
            "http://httparrot.herokuapp.com/robots.txt",
            "http://httparrot.herokuapp.com/deny",
            "http://httparrot.herokuapp.com/cache",
            "http://httparrot.herokuapp.com/stream-bytes/1024",
            "http://httparrot.herokuapp.com/base64/LytiYXNlNjQrLw",
            "http://httparrot.herokuapp.com/image",
            "http://httpbin.org"
          ]
        }
      }

      iex> URLParser.fetch("https://help.tableau.com/settings.json")
      {:ok, %{assets: [], links: []}}

      iex> URLParser.fetch("inavlid-or-dummy-url.te")
      {:error, "Invalid URL"}
  """

  # Here, we are assuming this url will return only html data in response
  def fetch(url) do
    with {:ok, %URI{host: host, scheme: scheme}} <- Utils.parse_and_validate_url(url),
         {:ok, %HTTPoison.Response{body: page_response, status_code: 200}} <-
           HttpAdapter.get(url),
         assets <-
           Utils.parse_data_to_get_valid_urls(page_response, "img", "src", "#{scheme}://#{host}"),
         links <-
           Utils.parse_data_to_get_valid_urls(page_response, "a", "href", "#{scheme}://#{host}") do
      {:ok, %{assets: assets, links: links}}
    else
      {:error, :invalid_url} ->
        {:error, "Invalid URL"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "#{status_code}: Unknown error while fetching data"}
    end
  end
end
