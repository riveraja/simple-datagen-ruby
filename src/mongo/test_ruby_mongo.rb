#!/usr/bin/ruby

require 'mongo'
require 'faker'

Mongo::Logger.logger.level = Logger::WARN
conn = Mongo::Client.new(['mongo0:27017', 'mongo1:27017', 'mongo2:27017'], :database => 'meeting', :replica_set => 'm0', :app_name => 'rubytest', :auth_source => 'meeting', :write_concern => { :w => 1 }, :read_concern => { :level => 'majority'})

=begin
rs = conn[:attendees].find().limit(10)
rs.each do |doc|
    p "==============================="
    doc.each do |k,v|
        p "#{k} #{v}"
    end
end
=end

5000000.times do |r|
    fname = Faker::Name.first_name
    lname = Faker::Name.last_name
    cname = Faker::Company.name
    email = "%{f}.%{l}@%{c}.com" % {f: fname, l: lname, c: cname}
    dt = Faker::Time.between(from: DateTime.now - 5, to: DateTime.now)
    regdate = dt.to_time.utc

    conn[:registration].insert_one( { :firstName => fname, :lastName => lname, :companyName => cname, :registration_date => regdate } )
end

conn.close
