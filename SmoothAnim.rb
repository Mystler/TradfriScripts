require_relative "lib/tradfri"

# Fade an array of bulbs and wait for the duration
def fade(bulbs, fade, color)
  bulbs.each do |b|
    b.fade = fade
    b.color = color
  end
  sleep(fade)
end

t = Tradfri::Client.new
bulbs = t.devices
fade bulbs, 1, [0, 0]
fade bulbs, 10, Tradfri::Colors::PERU
