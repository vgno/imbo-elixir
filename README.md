# ImboConnector

Allows interfacing with an Imbo installation using Elixir.

## Installation

Add `imbo_connector` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:imbo_connector, "~> 2.1.0"}
  ]
end
```

Next, add the following config to your `config/config.exs`:

```
config :imbo_connector,
  public_key: "PUBLIC_KEY",
  user: "USER",
  private_key: "PRIVATE_KEY",
  imbo_url: "LINK_TO_IMBO_INSTALL_ROOT"
```

## Usage

```elixir
ImboElixir.get_uploads
# => {:ok, %{images => [%{}]}

ImboElixir.upload("/path/to/image.jpg")
# => {:ok, %{}}

ImboElixir.delete("image_id")
# => {:ok, %{"imageIdentifier" => "image_id"}}

ImboElixir.construct_image_url("imageIdentifier")
# => "https://IMBO_INSTALLATION_URL/users/USER/images/IMAGE_IDENTIFIER?accessToken=ACCESS_TOKEN"

```
