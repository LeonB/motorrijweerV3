desc "Import knmi stations"
task :import_knmi_stations => :environment do

  # From KNMI gem
  KNMI::Station.send(:stations).each do |knmi_station|
    station = Station.where("lower(name) =?", knmi_station.name)
    if not station.nil?
      print knmi_station.name + "\n"
    end
    print "---------------\n"
  end
end
