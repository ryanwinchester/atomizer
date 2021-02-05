defmodule Atomizer.Scraper.Funimation do
  @moduledoc """
  Web Scraper for Funimation
  """

  alias Atomizer.Episode
  alias Atomizer.Provider
  alias Atomizer.Show

  @base_url "https://prod-api-funimationnow.dadcdigital.com/api"

  @doc """
  Scrape a Funimation web page for the required data.
  """
  def scrape(url) do
    search_result =
      url
      |> title_slug()
      |> search_show()
      |> get_in(["items", "hits"])
      |> List.first()

    episodes_result =
      search_result
      |> Map.fetch!("id")
      |> list_episodes()

    search_result
    |> to_show()
    |> add_episodes_to_show(episodes_result)
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
    get("/funimation/episodes",
      title_id: title_id,
      limit: -1,
      sort: "order",
      sort_direction: "DESC"
    )
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

  def to_show(search_result) do
    %{
      "id" => title_id,
      "description" => description,
      "ratings" => ratings,
      "title" => title,
      "slug" => slug,
      "image" => %{
        "showDetailHeaderDesktop" => cover,
        "showThumbnail" => thumbnail,
        "showKeyart" => keyart
      }
    } = search_result

    %Show{
      id: title_id,
      title: title,
      slug: slug,
      description: description,
      ratings: ratings,
      cover: cover,
      thumbnail: thumbnail,
      keyart: keyart,
      url: "https://funimation.com/shows/#{slug}",
      provider: funimation_provider()
    }
  end

  def add_episodes_to_show(%Show{} = show, episodes_result) do
    episodes =
      episodes_result
      |> Map.fetch!("items")
      |> Enum.map(fn episode ->
        %{
          "itemId" => id,
          "starRating" => star_rating,
          "synopsis" => synopsis,
          "thumb" => thumb,
          "title" => title,
          "item" => %{
            "seasonNum" => season,
            "episodeNum" => number,
            "episodeSlug" => slug,
            "runtime" => runtime
          },
          "mostRecentSvod" => %{
            "startDate" => timestamp
          }
        } = episode

        %Episode{
          id: id,
          number: number,
          runtime: runtime,
          season: season,
          slug: slug,
          star_rating: star_rating,
          synopsis: synopsis,
          thumbnail: thumb,
          timestamp: timestamp,
          title: title,
          url: "#{show.url}/#{slug}/simulcast"
        }
      end)

    %{show | episodes: episodes}
  end

  ## Helpers

  defp funimation_provider do
    %Provider{
      name: "Funimation",
      slug: "funimation",
      url: "https://funimation.com",
      logo: "https://upload.wikimedia.org/wikipedia/commons/4/47/Funimation_2016.svg",
      accent_color: "410099"
    }
  end

  defp ssl_options, do: [cacertfile: CAStore.file_path()]
end
