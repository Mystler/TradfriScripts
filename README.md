TradfriScripts
==============

Very basic Ruby scripts to control IKEA Trådfri Lights via the Trådfri Gateway and create custom programs for them.

Prerequisites
-------------

Assuming you have Ruby installed and got the prerequisite gems via bundler, you also need the coap-client from [libcoap](https://github.com/obgm/libcoap).
Make sure it supports DTLS. Compiling that one can be a bit tedious, especially on Windows, but is not in the scope of this README.

Then, copy the file `tradfri.sample.yml` to `tradfri.yml` and edit the values to match your needs.
- `coap_client` should be set to your coap-client executable.
- `username` is an arbitrary identifier for your app. If you just registered a username and missed the key, registration may fail and you have to use another one.
- `gateway_code` is the code on the bottom of the Trådfri gateway.
- `gateway_ip` is the gateway's IP address. These scripts do not support automatic discovery. Check your router's DHCP list for the gateway, or so.

Connecting to the gateway for the first time will request a personal key for the username you specified. This key will be stored in `tradfri.psk` by default.

In custom scripts, you can also specify other filenames for the config and key files. (See example below.)

Usage
-----

Now, you can run my scripts or create your own ones.

Quick explanation in code:

```ruby
require_relative "lib/tradfri"

t = Tradfri::Client.new # Initializes the connection, error handling if sth goes wrong may not be great.
t_alt = Tradfri::Client.new("config.yml", "cache.psk") # You can also change the defaults for config and key cache.

devices = t.devices # Returns all devices as an array of Tradfri::Device.
groups = t.groups # Returns all groups as an array of Tradfri::Group.
groups.each do |g|
  g.name # Returns the name of the group
  devices = g.devices # Returns group devices as an array of Tradfri::Device.
  devices.each do |d|
    # Getters
    d.name # Returns the name of the device.
    d.on? # Returns true if powered or false if not.

    # Commands
    d.on
    d.off
    d.toggle # Switch on if off or off if on

    # Accessors (can use to get or set)
    d.color # Returns an array of x and y values for the color. These are integers in range 0 to 65535.
    d.color = [30893, 26896] # Set light to a custom x, y color.
    d.color = Tradfri::Colors::PERU # Set light to a predefined color, see colors.rb.
    d.dim # Get/set brightness as a relative value from 0.0 to 1.0.
    d.fade = 3 # Get/set the time for color transitions in seconds.
  end

  g.dim = 0.2 # Tradfri::Group is actually a subclass of Device, so you can use all commands directly on a group.
end
```

Getters will return 0 values if the corresponding fields do not exist for a given device type or for groups. Note that getters always request the latest data from the network, so cache data in variables if a new request is not necessary.

When writing sequences, remember you can use `sleep(seconds)` to wait between commands or until transitions finish.

Check out my scripts for ideas or further examples.

- `DayNightCycle.rb`: Fades through a day-night color simulation with 1 day in 30 minutes.
