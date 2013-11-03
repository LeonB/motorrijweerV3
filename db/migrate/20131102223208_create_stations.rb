class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string     :name
      t.belongs_to :region
      t.decimal    :latitude,  :precision => 10, :scale => 6
      t.decimal    :longitude, :precision => 10, :scale => 6
      t.timestamps
    end
  end
end
