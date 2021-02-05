defmodule AtomizerWeb.FeedController do
  use AtomizerWeb, :controller

  alias Atomizer.Scraper.Funimation

  def index(conn, %{"show" => show_url}) do
    uri = URI.parse(show_url)
    provider = get_provider(uri.host)
    items = Funimation.scrape(show_url)

    render(conn, "index.xml", provider: provider, items: items)
  end

  defp get_provider("www.funimation.com"), do: :funimation
end
