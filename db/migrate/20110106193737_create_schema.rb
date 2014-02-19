class CreateSchema < ActiveRecord::Migration
 def self.up
	create_table :adminusers do |t|
	  t.string :username, :null => false
	end

	create_table :bulletins do |t|
	  t.string :from, :null => false, :default => ""
	  t.text :message
	  t.date :validfrom, :null => false
	  t.date :validto, :null => false
	  t.string :createdBy, :null => false, :default => ""
	  t.string :freetext, :default => ""
	  t.integer :year7, :default => 0
	  t.integer :year8, :default => 0
	  t.integer :year9, :default => 0
	  t.integer :year10, :default => 0
	  t.integer :year11, :default => 0
	end
    end

    def self.down
	drop_table :adminusers
	drop_table :bulletins
    end
end
