desc "Import old stations.xml file"
task :import_stations => :environment do
  Region.delete_all
  Station.delete_all

  s = IO.read('/home/leon/Workspaces/prive/motorrijweer.nl/v1/stations.xml')
  xml = Hash.from_xml(s)

  xml['provincies']['provincie'].each do |provincie|
    r_provincie = Region.new
    r_provincie.name = provincie['name']
    r_provincie.save

    provincie['regios'].each do |regios|
      regios = regios.last
      if regios.is_a? Hash
        regios = [regios]
      end

      regios.each do |regio|
        r_region = Region.new
        r_region.parent_id = r_provincie.id
        r_region.name = regio['name']
        r_region.save

        next if not regio['stations']

        regio['stations'].each do |stations|
          stations = stations.last
          if stations.is_a? Hash
            stations = [stations]
          end

          stations.each do |station|
            r_station = Station.new
            r_station.region_id = r_region.id
            r_station.name = station['name']
            # r_station.code = station['code']
            r_station.latitude = station['coordinates']['latitude']
            r_station.longitude = station['coordinates']['longitude']
            r_station.save
          end
        end
      end
    end
  end
end
