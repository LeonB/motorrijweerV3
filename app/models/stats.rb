class Stats

  def self.station_observations_vs_forecasts(station, from_datetime, to_datetime)
    providers = [
      'forecast.io',
      'KNMI',
      # 'Weather Underground',
    ]

    stats = Hashie::Mash.new
    stats.timepoints = []
    stats.stations = []

    # calculate each between from_date and to_date
    # Because it's _to_ drop the last item
    stats.timepoints =
      (from_datetime.to_i..to_datetime.to_i).step(1.hour).map { |i|
      Time.zone.at(i) }[0...-1]

    [station].each do |station|
      station_stats = Hashie::Mash.new
      station_stats.id = station.id
      station_stats.name = station.name
      station_stats.observations = Hashie::Mash.new
      station_stats.observations.providers = {}
      station_stats.forecasts = Hashie::Mash.new
      station_stats.forecasts.providers = {}
      stats.stations << station_stats

      providers.each do |provider|
        fs = self.get_provider_forecasts(provider, station, from_datetime, to_datetime)
        obs = self.get_provider_observations(provider, station, from_datetime, to_datetime)

        station_stats.forecasts.providers[provider] = []
        station_stats.observations.providers[provider] = []

        stats.timepoints.each do |t|
          if fs.has_key?(t)
            # Create a custom model proxy?
            # Komt iig voor bij weather underground: die hebben meerdere
            # meetpunten per uur
            station_stats.forecasts.providers[provider] << fs[t].first
          else
            station_stats.forecasts.providers[provider] << nil
          end

          if obs.has_key?(t)
            # Create a custom model proxy?
            station_stats.observations.providers[provider] << obs[t].first
          else
            station_stats.observations.providers[provider] << nil
          end
        end
      end
    end

    return stats
  end

  def self.get_provider_forecasts(provider, station, from_datetime, to_datetime)
    get_provider_stats(provider, station, from_datetime, to_datetime, 'forecasts')
  end

  def self.get_provider_observations(provider, station, from_datetime, to_datetime)
    get_provider_stats(provider, station, from_datetime, to_datetime, 'observations')
  end

  def self.get_provider_stats(provider, station, from_datetime, to_datetime, stats_type)
    cls = stats_type.singularize.classify.constantize

    # <= because to_datetime is already on the next hour, not smaller then
    return cls
      .where(:provider => provider)
      .where(:station=> station)
      .where('from_datetime >= ?', from_datetime)
      .where('to_datetime <= ?', to_datetime)
      .order(:from_datetime)
      .group_by {|f| f.from_datetime.beginning_of_hour }
  end
end
