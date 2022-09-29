# URLParser

An OTP application to fetch data from given URL, Parse received data, and then save parsed data to `%{assets: [], links: []}` format.

Using this application you can easily perform URL fetch operation when response structure for that page is in HTML.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `url_parser` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:url_parser, "~> 0.1.0"}
  ]
end
```

## Usage
  Fetch data based on provided URL and return an object with keys {`assets` & `links`}.

  PS: Currently, return expected results for valid URLs which return HTML page as response
  containing `<img>` & `<a>` tags. However, enhancement can be done to handle different types of url.
 
  Examples:
  ```elixir
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
  ```


#### Test Coverage
![Test coverage](https://user-images.githubusercontent.com/20892499/193096159-4c89ac1c-a68e-464e-85b2-a4618092e522.png)
