defmodule Atomizer.Episode do
  @moduledoc """
  The Episode struct.
  """

  @enforce_keys [:title, :number, :season, :url, :thumbnail, :timestamp]

  defstruct [
    :id,
    :number,
    :runtime,
    :season,
    :slug,
    :star_rating,
    :synopsis,
    :thumbnail,
    :timestamp,
    :title,
    :url
  ]
end
