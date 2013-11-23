require 'ruby-units'

module WeatherProviders
  class WeatherProvider

    attr_accessor :records

    def initialize
      self.records = []
    end

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

    def forecast(station)
      f = Forecast.new
      f.station_id = station.id
      f.provider = self.class::PROVIDER
      return f
    end

    # Match the forecast's data with the database
    # If it exists: merge the data??
    # If not: just save it
    def save(data)
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
      f.save

      self.records << f
      return f
    end

  end
end
