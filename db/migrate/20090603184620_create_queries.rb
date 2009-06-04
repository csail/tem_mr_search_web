class CreateQueries < ActiveRecord::Migration
  def self.up
    create_table :queries do |t|
      t.string :start_city
      t.string :end_city
      t.integer :layover_cost
      t.integer :time_cost
      t.integer :duration_cost

      t.timestamps
    end
  end

  def self.down
    drop_table :queries
  end
end
