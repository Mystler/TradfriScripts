require_relative "lib/tradfri"

t = Tradfri::Client.new
t.devices.each do |d|
  puts d.data
end
