require 'ruby-units'

module WeatherProviders
  class WeatherProvider
    PERIOD_MINUTE = 1.minute
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

    def import_forecasts(station)
      self.send(:initialize)
      api_data = self.get_api_data(station)
      yield(api_data)
      pp "Processed #{self.results[:processed]} forecasts"
      pp "Created #{self.results[:created]} forecasts"
      pp "Updated #{self.results[:updated]} forecasts"
      pp "Skipped #{self.results[:skipped]} forecasts"
      pp "#{self.results[:failed]} forecasts failed saving"
    end

    def get_api_data(station)
      yield
    end
    cache_method :get_api_data, 60.minutes.to_i

    def collect_data(*args)
      data = {}

      Forecast.column_names.each do |column_name|
        method_name = "get_#{column_name}"
        if self.respond_to? method_name
          value = self.send(method_name, *args)
          data[column_name.to_sym] = value
          # self.instance_eval(method_name) = value
        end
      end

      return data
    end

    def get_station_id(station, data, period)
      return station.id
    end

    def get_provider(station, data, period)
      return self.class::PROVIDER
    end

    # Match the forecast's data with the database
    # If it exists: merge the data??
    # If not: just save it
    def save(data)
      self.results[:processed] += 1

      f = Forecast.where(
        :station_id => data[:station_id],
        :from_datetime => data[:from_datetime],
        :to_datetime => data[:to_datetime],
        :provider => data[:provider]
      ).first_or_initialize

      attributes = data.each do |attr, value|
          next if attr == Forecast.primary_key
          next if f.send(:all_timestamp_attributes).include?(attr.to_sym)
          Forecast.column_names.include?(attr.to_s)
      end

      f.attributes = attributes
      new_record = f.new_record?
      changed = f.changed?

      if not changed
        self.results[:skipped] += 1
        return f
      end

      if not f.save
        pp "Could not save forecast. Errors: #{f.errors.messages}"
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

  end
end
