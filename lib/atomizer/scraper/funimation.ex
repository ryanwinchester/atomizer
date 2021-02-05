defmodule Atomizer.Scraper.Funimation do
  @moduledoc """
  Web Scraper for Funimation
  """

  @base_url "https://prod-api-funimationnow.dadcdigital.com/api"

  @doc """
  Scrape a Funimation web page for the required data.
  """
  def scrape(url) do
    episodes_result =
      url
      |> title_slug()
      |> search_show()
      |> get_in(["items", "hits", Access.at(0), "id"])
      |> list_episodes()

    IO.inspect(episodes_result, limit: :infinity)
  end

  @doc """
  Search the show by the title slug.
  """
  def search_show(text) do
    get("/source/funimation/search/auto", unique: "true", limit: 1, offset: 0, q: text)
  end

  @doc """
  List the episodes from funimation API.
  """
  def list_episodes(title_id) do
    get("/funimation/episodes", title_id: title_id, limit: -1, sort: "order", sort_direction: "DESC")
  end

  @doc """
  Make a GET request to funimation API.
  """
  def get(path, query) do
    case Tesla.get(client(), path, query: query) do
      {:ok, %{status: 200, body: body}} ->
        body

      error ->
        raise "Unable to fetch JSON: #{inspect(error)}"
    end
  end


  @doc """
  Build the HTTP client for dadcdigital.
  """
  def client do
    middleware = [
      {Tesla.Middleware.BaseUrl, @base_url},
      Tesla.Middleware.DecodeJson,
      Tesla.Middleware.FollowRedirects
    ]

    adapter = {Tesla.Adapter.Hackney, [ssl_options: ssl_options()]}

    Tesla.client(middleware, adapter)
  end

  @doc """
  Get the title slug from the funimaiton URL.
  """
  def title_slug(url) do
    url
    |> URI.parse()
    |> Map.fetch!(:path)
    |> String.trim("/")
    |> String.split("/")
    |> List.last()
  end

  ## Helpers

  defp ssl_options, do: [cacertfile: CAStore.file_path()]

  # defp funimation_headers do
  #   [
  #     {"accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"},
  #     {"accept-Encoding", "gzip, deflate, br"},
  #     {"accept-Language", "en-US,en;q=0.5"},
  #     {"cache-control", "no-cache"},
  #     # {"Connection", "keep-alive"},
  #     # {"Cookie", "visid_incap_998813=LxfHz7P7SQuRLpx+KCrv2HJdkV8AAAAAQUIPAAAAAADerzGZtfW4J5/g+WS577MM; region=CA; csrftoken=PvfGFDzXCiWXPZhPSNpyrcIZY0miZFfE46L0IiZkaMg15OjT6LRGmWDlQPAdZt3w; forum_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkZ1blVzZXI2MDM5ODIwIiwiZW1haWwiOiJmdW5na3UrZnVuaW1hdGlvbkBnbWFpbC5jb20iLCJpZCI6IjI2NDc5NDgifQ.FW2QgTXT9c9illlsAgfCD41Di_poH6s1Xim7uYRZUcY; authedCartId=99543558; terms-privacy-consent=true; lastVisitedLogin=/shows/mushoku-tensei-jobless-reincarnation/; src_user_id=6039820; src_token=f40c14804610383b3c0ed451596b397b7cee81d1; PIsession=6039820; rlildup=ca%3Atrue%3Aen%3Aweb%3Aca_premium_monthly_playstation; nlbi_998813=xuQGQUUQlV+ulhBnXrj7NgAAAAAj8mrw3RuMDXE7FADj9TpU; incap_ses_1228_998813=SYLfY/W9kmlVm0RTxLsKEQB0HGAAAAAA/MxiFTGwm9qt/pbCQ/eakQ==; LANGUAGE_PREFERENCE=en-us; sessionid=3weqvkccvlfkwri4590fg11b9ld4ofs1; userState=Subscriber; subscriptionMethod=PayPal; region=CA; addOns=; incap_ses_217_998813=vUcHc1RaPgd+lwn1mvACAzBiHGAAAAAAL2L871iJ0aPr3IbC/Ka2hw=="},
  #     {"dnt", "1"},
  #     {"host", "www.funimation.com"},
  #     {"pragma", "no-cache"},
  #     {"te", "Trailers"},
  #     {"upgrade-insecure-requests", "1"},
  #     {"user-agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:85.0) Gecko/20100101 Firefox/85.0"},
  #   ]
  # end
end
