defmodule ColdestCity.TempProcessor do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {ColdestCity.CityProducer, []},
        transformer: {__MODULE__, :transform, []},
        rate_limiting: [
          allowed_messages: 60,
          interval: 60_000
        ]
      ],
      processors: [
        default: [concurrency: 5]
      ]
    )
  end

  @impl Broadway
  def handle_message(:default, message, _context) do
    Message.update_data(message, &do_process_message/1)
  end

  def transform(event, _opts) do
    %Message{
      data: event,
      acknowledger: {__MODULE__, :ack_id, :ack_data}
    }
  end

  def ack(:ack_id, _successful, _failed) do
    :ok
  end

  defp do_process_message({city, country}) do
    case ColdestCity.TempFetcher.fetch_city_temp(city, country) do
      {:ok, city_temp} ->
        city_data = {city, country, city_temp}
        ColdestCity.TempTracker.maybe_update_coldest_city(city_data)

      _ ->
        nil
    end
  end
end
