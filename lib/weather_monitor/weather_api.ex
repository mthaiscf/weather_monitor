defmodule WeatherMonitor.WeatherAPI do

  @api_key "531464162a841b397029672cba4fb096"
  @base_url "http://api.openweathermap.org/data/2.5/weather"

  def get_weather(city) do

    url = "#{@base_url}?q=#{city}&appid=#{@api_key}&units=metric"

    case HTTPoison.get(url) do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body |> Jason.decode!}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "API request failed with status code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Request failed: #{reason}"}

    end

  end

end
