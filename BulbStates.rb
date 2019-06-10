require_relative "lib/tradfri"

t = Tradfri::Client.new
t.devices.each do |b|
  puts "#{b.name} - Power #{b.on?}, #{b.dim * 100}%, Color #{b.color}"
end
