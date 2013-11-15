require 'ruby-units'

module WeatherProviders
  class WeatherProvider

    def collect_data(api_data_point)
      data = {}

      Forecast.column_names.each do |column_name|
        method_name = "get_#{column_name}"
        if self.respond_to? method_name
          value = self.send(method_name, api_data_point)
          data[column_name] = value
          # self.instance_eval(method_name) = value
        end
      end

      return data
    end

  end
end
