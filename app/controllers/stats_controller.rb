class StatsController < ApplicationController

  def index
    providers = [
      # 'forecast.io',
      'Weather Underground',
    ]

    @station = Station.find_by(:name => 'Kloosterzande')
    from_datetime = (Date.current - 3.day).beginning_of_day
    to_datetime = (Date.current - 1.day).beginning_of_day
    @from_datetime = from_datetime
    @to_datetime = to_datetime

    # calculate each between from_date and to_date
    # Because it's _to_ drop the last item
    @timepoints =
      (from_datetime.to_i..to_datetime.to_i).step(1.hour).map { |i|
      Time.zone.at(i) }[0...-1]

    @stats = Hashie::Mash.new

    # Timepoints are TimeWithZone objects
    # @key = @timepoints.third
    # @ding = @forecastio_observations[@key]

    providers.each do |provider|
      fs = self.get_provider_forecasts(provider, @station, from_datetime, to_datetime)
      obs = self.get_provider_observations(provider, @station, from_datetime, to_datetime)
      @fs = fs
      @obs = obs

      @stats[provider] = Hashie::Mash.new
      @stats[provider].forecasts = Hashie::Mash.new
      @stats[provider].observations = Hashie::Mash.new

      @timepoints.each do |t|
        if fs.has_key?(t)
          # Create a custom model proxy?
          # Komt iig voor bij weather underground: die hebben meerdere
          # meetpunten per uur
          @stats[provider].forecasts[t] = fs[t].first
        else
          @stats[provider].forecasts[t] = nil
        end

        if obs.has_key?(t)
          # Create a custom model proxy?
          @stats[provider].observations[t] = obs[t].first
        else
          @stats[provider].observations[t] = nil
        end
      end
    end
  end

  def get_provider_forecasts(provider, station, from_datetime, to_datetime)
    get_provider_stats(provider, station, from_datetime, to_datetime, 'forecasts')
  end

  def get_provider_observations(provider, station, from_datetime, to_datetime)
    get_provider_stats(provider, station, from_datetime, to_datetime, 'observations')
  end

  def get_provider_stats(provider, station, from_datetime, to_datetime, stats_type)
    cls = stats_type.singularize.classify.constantize

    # <= because to_datetime is already on the next hour, not smaller then
    return cls
      .where(:provider => provider)
      .where(:station=> station)
      .where('from_datetime >= ?', from_datetime)
      .where('to_datetime <= ?', to_datetime)
      .order(:from_datetime)
      .group_by {|f| f.from_datetime.round(1.hour) }
  end
end
