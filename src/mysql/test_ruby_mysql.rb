#!/usr/bin/ruby

require 'mysql2'
require 'faker'

puts "Starting to load data..."

conn = Mysql2::Client.new(:host => "10.84.148.185", :username => "myuser", :password => "mypass", :port => 3306, :database => "test")

conn.query("CREATE TABLE IF NOT EXISTS \
    rubytest (id INT PRIMARY KEY AUTO_INCREMENT, \
    fname VARCHAR(100), \
    lname VARCHAR(100) \
    ) engine=InnoDB")

1000.times do |i|
    firstname = Faker::Name.first_name
    lastname = Faker::Name.last_name

    stmt = conn.prepare("INSERT INTO rubytest (fname, lname) VALUES (?,?)")
    stmt.execute(firstname,lastname)
end

conn.close
