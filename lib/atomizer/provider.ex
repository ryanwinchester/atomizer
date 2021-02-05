defmodule Atomizer.Provider do
  @moduledoc """
  The provider of the show.
  """

  @enforce_keys [:name, :slug]

  defstruct [:name, :slug, :url, :logo, :accent_color]
end
