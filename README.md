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

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/url_parser](https://hexdocs.pm/url_parser).
