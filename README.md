# ColdestCity
This is just a little project to experiment Broadway and GenStage.
Calling `ColdestCity.TempTracker.get_coldest_city/0` you can get the city with the lowest temperature of the ones provided in `ColdestCity.CityProducer.get_cities`.
The main components of the project are the following:
* `ColdestCity.CityProducer`: a GenStage producer that returns city names from an infinite stream
* `ColdestCity.TempProcessor`: a Broadway consumer that asks `ColdestCity.CityProducer` for cities and fetches temperature data for each of them
* `ColdestCity.TempTracker`: a simple Agent that keeps the city with the lowest temperature.

The project is based on this [article](https://akoutmos.com/post/using-broadway/), with a few tweaks here and there :).
To give it a spin you will need to get an [OpenWeatherMap](https://openweathermap.org/) API key and put it in an env variable called `OPENWEATHERMAP_KEY`.

