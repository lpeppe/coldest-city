defmodule ColdestCity.CityProducer do
  use GenStage

  def start_link(_args) do
    GenStage.start_link(__MODULE__, [])
  end

  def init(_args) do
    {:producer, 0}
  end

  def handle_demand(demand, stream_cursor) do
    {cities_stream, cities_count} = get_cities()

    requested_cities =
      cities_stream
      |> Stream.drop(stream_cursor)
      |> Enum.take(demand)

    next_stream_cursor =
      stream_cursor
      |> Kernel.+(demand)
      |> Integer.mod(cities_count)

    {:noreply, requested_cities, next_stream_cursor}
  end

  defp get_cities do
    cities = [
      {"Milan", "Italy"},
      {"Barcelona", "Spain"},
      {"Avellino", "Italy"},
      {"Manchester", "England"}
    ]

    {Stream.cycle(cities), length(cities)}
  end
end
