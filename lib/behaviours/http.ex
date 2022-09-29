defmodule URLParser.Behaviours.Http do
  @moduledoc """
  HTTP API interface
  """

  @callback get(url :: String.t()) :: {:ok, any()} | {:error, any()}

  def get(url), do: impl().get(url)

  defp impl, do: Application.get_env(:url_parser, :http_adapter)
end
