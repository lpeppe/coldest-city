defmodule ColdestCity.TempTracker do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> nil end, name: __MODULE__)
  end

  def maybe_update_coldest_city({_new_city, _new_country, new_temp} = new_data) do
    Agent.update(__MODULE__, fn
      nil ->
        new_data

      {_old_city, _old_country, old_temp} when new_temp < old_temp ->
        new_data

      old_data ->
        old_data
    end)
  end

  def get_coldest_city do
    Agent.get(__MODULE__, & &1)
  end
end
