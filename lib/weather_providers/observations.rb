require 'ruby-units'

module WeatherProviders
  class Observations
    PERIOD_HOUR = 1.hour
    PERIOD_DAY = 1.day

    attr_accessor :results

    def initialize
      self.results = {
        :created   => 0,
        :failed    => 0,
        :processed => 0,
        :skipped   => 0,
        :updated   => 0
      }
    end

    # Collect api data, split it in periods and save per period
    def import_observations(station, date)
      self.send(:initialize)
      api_data = self.get_api_data(station, date)

      # Check for hourly data
      self.collect_processed_hourly_data(station, api_data).each do |d|
        self.save(d)
      end if self.supported_periods.include? PERIOD_HOUR

      # Check for daily data
      self.collect_processed_daily_data(station, api_data).each do |d|
        self.save(d)
      end if self.supported_periods.include? PERIOD_DAY

      Rails.logger.debug "Processed #{self.results[:processed]} observations"
      Rails.logger.debug "Created #{self.results[:created]} observations"
      Rails.logger.debug "Updated #{self.results[:updated]} observations"
      Rails.logger.debug "Skipped #{self.results[:skipped]} observations"
      Rails.logger.debug "#{self.results[:failed]} observations failed saving"
      return self.results
    end

    # Delegates the collecting of api_data to child classes
    def get_api_data(station)
      yield
    end
    cache_method :get_api_data, 60.minutes.to_i

    # Convert api_data to AR data based on the available methods in that
    # weatherprovider class
    def convert_data(*args)
      data = {}

      Observation.column_names.each do |column_name|
        method_name = "get_#{column_name}"
        if self.respond_to? method_name
          value = self.send(method_name, *args)
          data[column_name.to_sym] = value
        end
      end

      return data
    end

    def get_period(station, data, period)
      if period == self.class::PERIOD_HOUR
        return 'hour'
      elsif period == self.class::PERIOD_DAY
        return 'day'
      end
    end

    def get_station_id(station, data, period)
      return station.id
    end

    def get_provider(station, data, period)
      return self.class::PROVIDER
    end

    # Match the observation's data with the database
    # If it exists: merge the data??
    # If not: just save it
    def save(data)
      self.results[:processed] += 1

      # Create an observation from the data
      f = self.observation_from_data(data)

      new_record = f.new_record?
      changed = f.changed?

      if not changed
        self.results[:skipped] += 1
        return f
      # else
      #   changes = f.changes
      #   changes.each do |i, data|
      #     data[0] = data[0].to_s
      #     data[1] = data[1].to_s
      #   end
      #   Rails.logger.debug changes
      end

      if not f.save
        Rails.logger.debug "Could not save observation. Errors: #{f.errors.messages}"
        self.results[:failed] += 1
        return f
      end

      if new_record
        self.results[:created] += 1
      elsif changed
        self.results[:updated] += 1
      end

      return f
    end

    def observation_from_data(data)
      # Find observation or create a new one
      f = Observation.where(
        :station_id => data[:station_id],
        :from_datetime => data[:from_datetime],
        :to_datetime => data[:to_datetime],
        :provider => data[:provider]
      ).first_or_initialize

      # Collect all attributes that match a field in the observation model
      attributes = data.each do |attr, value|
          next if attr == Observation.primary_key
          next if f.send(:all_timestamp_attributes).include?(attr.to_sym)
          Observation.column_names.include?(attr.to_s)
      end

      # Add collected attributes to observation
      f.attributes = attributes

      return f
    end

  end
end

