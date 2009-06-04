class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.integer :query_id
      t.integer :record_id
      t.integer :score
      t.integer :start_time
      t.integer :end_time
      t.integer :price
      t.integer :layovers
      t.string :start_city
      t.string :end_city

      t.timestamps
    end
  end

  def self.down
    drop_table :results
  end
end
