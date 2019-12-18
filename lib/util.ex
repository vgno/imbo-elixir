defmodule ImboConnector.Util do

    def strip_access_token(url) do
        # Strip access token from URL.
        without_access =
            url
            |> String.split("?")
            |> Enum.fetch!(-1)
            |> URI.decode_query
            |> Map.delete("accessToken")
            |> URI.encode_query

        case String.length(without_access) do
            0 ->
                url_no_params(url)

            _ ->
                url
                |> url_no_params
                |> Kernel.<> "?#{without_access}"
        end
    end

    def url_no_params(url) do
        url
        |> String.split("?")
        |> Enum.fetch!(0)
    end

    def add_query_param_symbol(url) do
        if String.contains?(url, "?") do
            url <> "&"
        else
            url <> "?"
        end
    end
end