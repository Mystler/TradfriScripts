require_relative "lib/tradfri"

# Fade a device or group and wait for the duration
def fade(unit, fade, color, output = nil)
  fade *= 75 # Convert pseudo hours to seconds, 75s per hour means 30min for 24h
  puts output if output
  unit.fade = fade
  unit.color = color
  sleep(fade)
end

t = Tradfri::Client.new
bulbs = t.groups.first
bulbs.on
fade bulbs, 0, Tradfri::Colors::APP_44

loop do
  fade bulbs, 2, Tradfri::Colors::APP_45, "Fading to Pre-Sunrise"
  fade bulbs, 4, Tradfri::Colors::APP_35, "Fading to Morning 1"
  fade bulbs, 1, Tradfri::Colors::APP_25, "Fading to Morning 2"
  fade bulbs, 2, Tradfri::Colors::APP_15, "Fading to Morning 3"
  fade bulbs, 2, Tradfri::Colors::APP_14, "Fading to Morning 4"
  fade bulbs, 2, Tradfri::Colors::APP_13, "Fading to Day"
  fade bulbs, 6, Tradfri::Colors::APP_12, "Fading to Sunset 1"
  fade bulbs, 2, Tradfri::Colors::APP_31, "Fading to Sunset 2"
  fade bulbs, 1, Tradfri::Colors::APP_42, "Fading to Evening 2"
  fade bulbs, 2, Tradfri::Colors::APP_44, "Fading to Night"
end
