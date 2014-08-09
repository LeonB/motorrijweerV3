namespace :providers do
  providers = {
    'forecast.io' => 'WeatherProviders::ForecastIo',
    'Weather Underground' => 'WeatherProviders::WeatherUnderground',
    'Yr.no' => 'WeatherProviders::YrNo'
  }

  namespace :all do
    desc "Import all forecasts"
    task :forecasts => :environment do
      Rails.logger = Logger.new(STDOUT)

      providers.each_with_index do |(provider_name, provider_class), i|
        provider = "#{provider_class}::Forecasts".constantize.new()
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

  namespace :all do
    desc "Import all observations"
    task :observations => :environment do
      Rails.logger = Logger.new(STDOUT)

      providers.each_with_index do |(provider_name, provider_class), i|
        provider = "#{provider_class}::Observations".constantize.new()
        stations = Station.all
        stations.each do |station|
          provider.import_observations(station)
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
      task :forecasts => :environment do
        Rails.logger = Logger.new(STDOUT)

        provider = "#{provider_class}::Forecasts".constantize.new()
        stations = Station.all
        stations.each do |station|
          provider.import_forecasts(station)
          if not station == stations.last
            puts '------------------------'
          end
        end
      end # task

      desc "Import #{provider_name} observations"
      task :observations, [:date] => [:environment] do |t, args|
        Rails.logger = Logger.new(STDOUT)

        if not args[:date]
          Rails.logger.fatal "Please specify a date: rake #{namespace_name}:#{provider_name}:#{t}[YYYY-MM-DD]"
          exit
        else
          date = Date.parse(args[:date])
        end

        provider = "#{provider_class}::Observations".constantize.new()
        stations = Station.all
        stations.each do |station|
          provider.import_observations(station, date)
          if not station == stations.last
            puts '------------------------'
          end
        end
      end # task
    end # namespace
  end # each

end
