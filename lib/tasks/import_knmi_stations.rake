desc "Import knmi stations"
task :import_knmi_stations => :environment do

  # From KNMI gem
  KNMI::Station.send(:stations).each do |knmi_station|
    print knmi_station.to_json
    print "\n"
    station = Station.find_by("lower(name) =?", knmi_station.name.downcase)

    # Station exists: skip it
    if not station.nil?
      next
    end

    # Find region by coördinates
    # station = Station.new(
    #   :name => knmi_station.name,
    #   :latitude => knmi_station.lat,
    #   :longitude => knmi_station.lng,
    # ).save()

    print knmi_station.name + "\n"
    print "---------------\n"
  end
end
