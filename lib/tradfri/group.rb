require_relative "client"
require_relative "device"

module Tradfri
  class Group < Device
    PATH = "15004"

    def devices
      list = []
      data["9018"]["15002"]["9003"].each do |id|
        list.push(Device.new(@client, id))
      end
      return list
    end

    protected

    def set_control(hash)
      @client.put(@path, hash)
    end
  end
end
