defmodule ImboConnectorTest do
  use ExUnit.Case
  use Mix.Config

  doctest ImboConnector

  test "all config variables gets set correctly" do
    public_key = Application.get_env(:imbo_connector, :public_key)
    user = Application.get_env(:imbo_connector, :user)
    private_key = Application.get_env(:imbo_connector, :private_key)
    imbo_url = Application.get_env(:imbo_connector, :imbo_url)

    assert public_key == "public_key"
    assert user == "user"
    assert private_key == "private_key"
    assert imbo_url == "imbo_url"
  end

  test "get_uploads/0 returns error with wrong credentials" do
    case ImboConnector.get_uploads() do
      {:error, error} ->
        assert error
    end
  end

  test "upload/1 returns error with wrong credentials" do
    case ImboConnector.upload("123123") do
      {:error, error} ->
        assert error
    end
  end
end
