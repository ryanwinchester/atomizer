defmodule AtomizerWeb.FeedView do
  use AtomizerWeb, :view

  alias Atomizer.Episode
  alias Atomizer.Show

  def updated_iso8601(%Show{} = show) do
    show.episodes
    |> List.first()
    |> updated_iso8601()
  end

  def updated_iso8601(%Episode{timestamp: timestamp}) do
    updated_iso8601(timestamp)
  end

  def updated_iso8601(datetime) when is_binary(datetime) do
    with {:ok, dt, 0} <- DateTime.from_iso8601(datetime) do
      DateTime.to_iso8601(dt)
    end
  end
end
