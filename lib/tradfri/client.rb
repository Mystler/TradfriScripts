require "json"
require "yaml"
require "open3"

require_relative "device"
require_relative "group"

module Tradfri
  class Client
    def initialize(config_file = "tradfri.yml", psk_file = "tradfri.psk")
      @psk_file = psk_file
      @config = YAML.load(File.read(config_file))
      begin
        @psk = File.read(psk_file)
      rescue => exception
        @psk = "notfound"
      end
      authenticate
    end

    def groups
      list = []
      get(Tradfri::Group::PATH).each do |id|
        list.push(Group.new(self, id))
      end
      return list
    end

    def devices
      list = []
      get(Tradfri::Device::PATH).each do |id|
        list.push(Device.new(self, id))
      end
      return list
    end

    def get(path)
      coap("get", @config["username"], @psk, path)
    end

    def put(path, payload)
      coap("put", @config["username"], @psk, path, payload)
    end

    private

    def coap(type, user, key, path, payload = nil)
      url = "coaps://#{@config["gateway_ip"]}:5684/#{path}"
      args = ["-m", type, "-u", user, "-k", key]
      args.push("-e", JSON.generate(payload)) if payload != nil
      args.push(url)
      out, status = Open3.capture2e(@config["coap_client"], *args)
      begin
        json = JSON.parse(out)
      rescue JSON::ParserError
        json = nil
      end
      return json
    end

    def register
      pl = {"9090": "#{@config["username"]}"}
      resp = coap("post", "Client_identity", @config["gateway_code"], "15011/9063", pl)
      if resp.is_a?(Hash)
        @psk = resp["9091"]
        File.open(@psk_file, "w") do |file|
          file.write @psk
        end
        puts "Registered"
      else
        raise "Registration failed!"
      end
    end

    def authenticate
      unless get("15001")
        register
      end
    end
  end
end
