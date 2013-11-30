# providers::forecast_io::forecast
# providers::wunderground::forecast

namespace :providers do
  providers = {
    'forecast.io' => 'WeatherProviders::ForecastIo',
    'Weather Underground' => 'WeatherProviders::WeatherUnderground'
  }

  namespace :all do
    desc "Import all forecasts"
    task :forecast => :environment do
      providers.each_with_index do |(provider_name, provider_class), i|
        provider = provider_class.constantize.new()
        stations = Station.all
        stations.each do |station|
          provider.import_forecasts(station)
          if not station == stations.last
            # Mark the end of a station
            puts '------------------------'
          end
        end
        if not i+1 == providers.size
          # Mark the end of a provider
          puts '------------------------'
        end
      end # providers
    end
  end

  providers.each do |provider_name, provider_class|
    namespace_name = provider_name.downcase
    namespace_name = namespace_name.gsub(' ', '')
    namespace_name = namespace_name.gsub('.', '')

    namespace :"#{namespace_name}" do
      desc "Import #{provider_name} forecasts"
      task :forecast => :environment do
        provider = provider_class.constantize.new()
        stations = Station.all
        stations.each do |station|
          provider.import_forecasts(station)
          if not station == stations.last
            puts '------------------------'
          end
        end
      end # task
    end # namespace
  end # each

  # namespace :forecast_io do
    # desc "Import forecast.io forecasts"
    # task :forecast => :environment do
      # provider = WeatherProviders::ForecastIo.new()
      # stations = Station.all
      # stations.each do |station|
        # provider.forecasts(station)
        # if not station == stations.last
          # puts '------------------------'
        # end
      # end
    # end
  # end

  # namespace :wunderground do
    # desc "Import weather underground forecasts"
    # task :forecast => :environment do
      # provider = WeatherProviders::WeatherUnderground.new()
      # stations = Station.all
      # stations.each do |station|
        # provider.forecasts(station)
        # if not station == stations.last
          # puts '------------------------'
        # end
      # end
    # end
  # end

end
