require_relative "client"

module Tradfri
  class Group
    PATH = "15004"

    attr_reader :id

    def initialize(client, id)
      @client = client
      @id = id
      @path = "#{PATH}/#{@id}"
    end

    def data
      @client.get(@path)
    end

    def name
      data["9001"]
    end

    def devices
      list = []
      data["9018"]["15002"]["9003"].each do |id|
        list.push(Device.new(@client, id))
      end
      return list
    end
  end
end
