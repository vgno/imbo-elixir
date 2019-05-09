defmodule ImboConnector do
  use Timex

  @moduledoc """
  Documentation for ImboConnector.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ImboConnector.hello()
      :world

  """
  def hello do
    :world
  end

  defp sign(data) do
    private_key = Application.get_env(:imbo_connector, :private_key)

    :crypto.hmac(:sha256, private_key, data)
    |> Base.encode16(case: :lower)
  end
end
