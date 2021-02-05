defmodule Atomizer.Show do
  @moduledoc """
  The show struct.
  """

  @enforce_keys [:title, :id, :thumbnail, :provider]

  defstruct [
    :id,
    :title,
    :slug,
    :description,
    :url,
    :ratings,
    :cover,
    :thumbnail,
    :keyart,
    :provider,
    episodes: []
  ]
end
