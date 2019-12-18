defmodule ImboConnector do
  use Timex

  alias ImboConnector.Util

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

  def delete(image_id) do
    base_url = generate_url("images") <> "/#{image_id}"
    timestamp = generate_timestamp()
    signature = sign_write("DELETE", timestamp, base_url)

    headers = [
      "X-Imbo-PublicKey": Application.get_env(:imbo_connector, :public_key),
      "X-Imbo-Authenticate-Signature": signature,
      "X-Imbo-Authenticate-Timestamp": timestamp
    ]

    base_url
    |> HTTPoison.delete(headers)
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

  def apply_transformation(url, %{} = options) do
    url_with_query =
      url
      |> Util.strip_access_token
      |> Util.add_query_param_symbol

    final_url= Enum.reduce(options, url_with_query, fn option, acc ->
      case option do
        {:compress, compress_value} ->
          acc <> "t[]=compress:level=#{compress_value}&"
        {:resize, [width, height]} ->
          acc <> "t[]=resize:width=#{width},height=#{height}&"
        {:resize, %{width: width}} ->
          acc <> "t[]=resize:width=#{width}&"
        {:resize, %{height: height}} ->
          acc <> "t[]=resize:height=#{height}&"

        _ ->
          acc
      end
    end)

    sign_url_for_read(final_url)
  end

  def create_thumbnail(url, %{width: width, height: height}) do
    url_with_query =
      url
      |> Util.strip_access_token
      |> Util.add_query_param_symbol

    sign_url_for_read(url_with_query <> "t[]=thumbnail:width=#{width},height=#{height},fit=inset&t[]=compress:level=50&")
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

  def sign_url_for_read(url) do

    if not String.contains?(url, "?") do
      url <> "&accessToken=#{sign(url)}"
    else
      if String.ends_with?(url, "&") do
        new_url = url |> String.slice(0..-2)

        new_url <> "&accessToken=#{sign(new_url)}"
      else
        url <> "&accessToken=#{sign(url)}"
      end
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
