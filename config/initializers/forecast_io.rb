ForecastIO.configure do |configuration|
  configuration.api_key = ENV['FORECAST_IO_API_KEY']
  configuration.default_params = {
    units: 'si',
    extend: 'hourly',
    exclude: 'minutely,alerts,flags',
  }
end
