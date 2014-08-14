// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require highcharts/highcharts.src.js
//= require highcharts/highcharts-more.src.js
//= require paloma
//= require moment
//= require moment/locale/nl.js

// $(function(){ $(document).foundation(); });

var StatsController = Paloma.controller('Stats');

// Executes when Rails User#new is executed.
StatsController.prototype.index = function() {
  // Setup chart
  var chart = new Highcharts.Chart({
    chart: {
      renderTo: $('#container')[0],
      type: 'column',
      type: 'spline'
    },
    title: {
      text: 'Monthly Average Temperature'
    },
    subtitle: {
      text: 'Source: WorldClimate.com'
    },
    xAxis: {
      // type: 'datetime',
      // dateTimeLabelFormats: {
      //   day: '%e of %b'
      // },
      tickInterval: 12, // half day
      labels: {
        step: 1
      },
      startOnTick: true
    },
    yAxis: {
      title: {
        text: 'Temperature (°C)'
      }
    },
    tooltip: {
      // valueSuffix: ' m/s'
    },
    plotOptions: {
      spline: {
        // enableMouseTracking: false,
        states: {
          hover: {
            lineWidth: 2
          }
        },
        marker: {
          enabled: false
        },
      },
      series: {
        stickyTracking: false,
        // pointWidth: 8
      }
    },
    series: []
  });

  // Get chart data
  $.getJSON('/stats/index.json', function(data) {

    var categories = data.timepoints.map(function(s) {
      var d = new Date(s);
      return moment(s).locale('nl').format('D MMM LT');
      return d.toLocaleString();
      return d;
    });

    var series = [];
    $.each(data.stations, function(i, station) {
      $.each(station.observations.providers, function(provider, observations) {
        var serie = {
          name: station.name + " " + provider + " observation " + "temperature",
          data: [],
        };

        $.each(observations, function(j, observation) {
          if (observation) {
            // serie.data.push(parseFloat(observation.temperature_in_celcius));
            serie.data.push(parseFloat(observation.precipitation_in_mm_per_hour));
          } else {
            serie.data.push(null);
          }
        });
        series.push(serie);
      });

      $.each(station.forecasts.providers, function(provider, forecasts) {
        var serie = {
          name: station.name + " " + provider + " forecast " + "temperature",
          data: [],
          // pointInterval: 24 * 3600 * 1000, // one day
          // pointStart: Date.UTC(2006, 0, 1)
        };

        $.each(forecasts, function(j, forecast) {
          if (forecast) {
            // serie.data.push(parseFloat(forecast.temperature_in_celcius_avg));
            serie.data.push(parseFloat(forecast.precipitation_in_mm_per_hour_avg));
          } else {
            serie.data.push(null);
          }
        });
        series.push(serie);
      });
    });

    // console.log(series);
    // console.log(categories[0]);

    // set x axis labels without redrawing
    chart.xAxis[0].setCategories(categories, false);

    // set data points without redrawing
    $.each(series, function (i, serie) {
      chart.addSeries(serie, false);
    });

    // redraw chart
    chart.redraw()

  }).fail(function() {
    // console.log('fail');
  });
};
