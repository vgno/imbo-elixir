defmodule ImboConnector do
  use Timex

  def upload(file_path) do
    base_url = generate_url("images")
    timestamp = generate_timestamp()
    signature = sign_write("POST", timestamp, base_url)

    headers = [
      "X-Imbo-PublicKey": Application.get_env(:imbo_connector, :public_key),
      "X-Imbo-Authenticate-Signature": signature,
      "X-Imbo-Authenticate-Timestamp": timestamp
    ]

    base_url
      |> HTTPoison.post({:file, file_path}, headers)
      |> handle_response()
  end

  def get_uploads do
    base_url = generate_url("images")

    headers = [
      "User-Agent": "ImboClient",
      Accept: "application/json"
    ]

    base_url
      |> sign_url_for_read()
      |> HTTPoison.get(headers)
      |> handle_response
  end

  def construct_image_url(id) do
    sign_url_for_read(generate_url("images") <> "/#{id}")
  end

  defp handle_response(response) do
    case response do
      {:ok, %HTTPoison.Response{body: body}} ->
        {:ok, Jason.decode!(body)}

      {:error, error} ->
        {:error, error}
    end
  end

  defp generate_timestamp() do
    Timex.now()
      |> Timex.format!("{ISO:Extended}")
      |> String.replace("+00:00", "")
      |> String.slice(0..18)
      |> Kernel.<>("Z")
  end

  defp sign(data) do
    private_key = Application.get_env(:imbo_connector, :private_key)

    :crypto.hmac(:sha256, private_key, data)
      |> Base.encode16(case: :lower)
  end

  defp sign_url_for_read(url) do
    signature = sign(url)

    if url =~ "?" do
      url <> "&accessToken=#{signature}"
    else
      url <> "?accessToken=#{signature}"
    end
  end

  defp sign_write(method, timestamp, url) do
    public_key = Application.get_env(:imbo_connector, :public_key)

    [method, url, public_key, timestamp]
      |> Enum.join("|")
      |> sign()
  end

  defp generate_url(resource) do
    base_url = Application.get_env(:imbo_connector, :imbo_url)
    user = Application.get_env(:imbo_connector, :user)

    base_url <> "/users/" <> user <> "/#{resource}"
  end
end
