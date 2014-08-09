desc "Import knmi stations"
task :import_knmi_stations => :environment do
  KNMI::Station.send(:stations).each do |knmi_station|
    station = Station.find_by(:name => knmi_station.name)
    print knmi_station.name + "\n"
    if not station.nil?
      print station.name + "\n"
    end
    print "---------------\n"
  end
end
