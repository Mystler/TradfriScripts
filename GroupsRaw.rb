require_relative "lib/tradfri"

t = Tradfri::Client.new
t.groups.each do |g|
  puts "Group #{g.name}"
  puts g.data
  g.devices.each do |d|
    puts "-- Device #{d.name}"
  end
  puts
end
