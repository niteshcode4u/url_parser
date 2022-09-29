defmodule URLParserTest do
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  @url "http://httparrot.herokuapp.com"

  describe "URLParser.fetch/1" do
    test "Success - fetch response, parse and then provide expected result when correct url provided" do
      page_response = """
        <!DOCTYPE html>URL
          <html>
            <body id='manpage'>URL
              <a href="http://github.com/edgurgel/httparrot">
                <img src="https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png" alt="Fork me on GitHub">
              </a>
              <a href="http://httparrot.herokuapp.com">HTTP</a>
              <a href="https://httparrot.herokuapp.com">HTTPS</a>
              <a href="/" data-bare-link="true"> </a>
              <a href="/ip" data-bare-link="true"></a>
              <a href="/user-agent" data-bare-link="true">
            </body>
          </html>
      """

      expect(HttpMock, :get, fn _endpoint ->
        {:ok, %HTTPoison.Response{body: page_response, status_code: 200}}
      end)

      assert {
               :ok,
               %{
                 assets: [
                   "https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png"
                 ],
                 links: [
                   "http://github.com/edgurgel/httparrot",
                   "http://httparrot.herokuapp.com",
                   "https://httparrot.herokuapp.com",
                   "http://httparrot.herokuapp.com",
                   "http://httparrot.herokuapp.com/ip",
                   "http://httparrot.herokuapp.com/user-agent"
                 ]
               }
             } == URLParser.fetch(@url)
    end

    test "Error - when invalid url provided" do
      assert {:error, "Invalid URL"} == URLParser.fetch("some-dummy-url-to-validate.tet")
    end

    test "Error - return empty incase url not for html page" do
      # set up
      page_response = """
        {"flags": {"debugConsoleEnabled": false}}
      """

      expect(HttpMock, :get, fn _endpoint ->
        {:ok, %HTTPoison.Response{body: page_response, status_code: 200}}
      end)

      assert {:ok, %{assets: [], links: []}} == URLParser.fetch(@url)
    end

    test "Error - time out when url take long time to response" do
      expect(HttpMock, :get, fn _endpoint ->
        {:error, %HTTPoison.Error{reason: :timeout}}
      end)

      assert {:error, :timeout} == URLParser.fetch(@url)
    end

    test "Error - unknown error while fetching data" do
      expect(HttpMock, :get, fn _endpoint ->
        {:ok, %HTTPoison.Response{status_code: 302}}
      end)

      assert {:error, "302: Unknown error while fetching data"} == URLParser.fetch(@url)
    end
  end
end
