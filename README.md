# ImboConnector

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `imbo_connector` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:imbo_connector, "~> 0.1.0"}
  ]
end
```

## Usage

Add config under `config/config.exs`.

```
config :imbo_connector,
  public_key: "PUBLIC_KEY",
  user: "USER",
  private_key: "PRIVATE_KEY",
  imbo_url: "LINK_TO_IMBO_INSTALL_ROOT"
```

## Functions

`get_uploads/0` returns all uploads for the set user
`upload/1` uploads image
`construct_image_url/1` returns image url based on body['imageIdentifier']
