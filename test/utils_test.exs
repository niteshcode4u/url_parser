defmodule URLParser.UtilsTest do
  use ExUnit.Case

  alias URLParser.Utils

  @url "http://httparrot.herokuapp.com"

  describe "Utils.parse_and_validate_url/1" do
    test "Success - return valid struct when correct url given" do
      assert {:ok,
              %URI{
                authority: "httparrot.herokuapp.com",
                fragment: nil,
                host: "httparrot.herokuapp.com",
                path: nil,
                port: 80,
                query: nil,
                scheme: "http",
                userinfo: nil
              }} == Utils.parse_and_validate_url(@url)
    end

    test "Error - return invalid url when incorrect url given" do
      assert {:error, :invalid_url} == Utils.parse_and_validate_url("dummy_url.tet")
    end
  end

  describe "Utils.parse_data_to_get_valid_urls/4" do
    test "Success - return valid struct when correct url given" do
      page_response = """
        <!DOCTYPE html>URL
          <html>
            <body id='manpage'>URL
              <a href="http://github.com/edgurgel/httparrot">
                <img src="https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png" alt="Fork me on GitHub">
              </a>
              <a href="http://httparrot.herokuapp.com">HTTP</a>
              <a href="https://httparrot.herokuapp.com">HTTPS</a>
            </body>
          </html>
      """

      assert ["https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png"] ==
               Utils.parse_data_to_get_valid_urls(
                 page_response,
                 "img",
                 "src",
                 "http://herokuapp.com"
               )

      assert [
               "http://github.com/edgurgel/httparrot",
               "http://httparrot.herokuapp.com",
               "https://httparrot.herokuapp.com"
             ] ==
               Utils.parse_data_to_get_valid_urls(
                 page_response,
                 "a",
                 "href",
                 "http://herokuapp.com"
               )
    end

    test "Error - return empty list when there is no data" do
      page_response = """
        {}
      """

      assert [] ==
               Utils.parse_data_to_get_valid_urls(
                 page_response,
                 "a",
                 "href",
                 "http://herokuapp.com"
               )
    end
  end
end
