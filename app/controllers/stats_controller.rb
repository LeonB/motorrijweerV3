class StatsController < ApplicationController

  def index
    @station = Station.find_by(:name => 'Westdorpe')
    # @station = Station.find_by(:name => 'De Bilt')
    @from_datetime = (Date.current - 7.day).beginning_of_day
    @to_datetime = (Date.current - 0.day).beginning_of_day

    respond_to do |format|
      format.html
      format.json do
        stats = Stats.station_observations_vs_forecasts(@station,
                                                        @from_datetime,
                                                        @to_datetime)
        render :json => stats.to_json
      end
    end

  end

end
