defmodule ImboConnectorTest do
  use ExUnit.Case
  doctest ImboConnector

  test "private key gets set correctly" do
    key = Application.get_env(:imbo_connector, :private_key)
    assert key == "private_key"
  end
end
