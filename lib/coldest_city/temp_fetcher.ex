defmodule ColdestCity.TempFetcher do
  require Logger

  @spec fetch_city_temp(String.t(), String.t()) :: {:ok, Float.t()} | :error
  def fetch_city_temp(city, state) do
    request_url = get_request_url(city, state)

    with {:ok, %HTTPoison.Response{body: body} = _response} <- HTTPoison.get(request_url),
         {:ok, decoded_data} <- Jason.decode(body) do
      current_temp = get_in(decoded_data, ["main", "temp"])

      {:ok, current_temp}
    else
      error ->
        Logger.debug("Something went wrong while fetching temperature data.", error: error)
        :error
    end
  end

  defp get_request_url(city, state) do
    "https://api.openweathermap.org/data/2.5/weather?q=#{city},#{state}&appid=#{api_key()}"
  end

  defp api_key, do: System.fetch_env!("OPENWEATHERMAP_KEY")
end
