class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string     :name
      t.string     :code
      t.integer    :parent_id
      t.integer    :lft
      t.integer    :rgt
      t.integer    :depth # this is optional.
      t.timestamps
    end
  end
end
