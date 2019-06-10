require_relative "client"

module Tradfri
  class Device
    PATH = "15001"

    attr_reader :id
    attr_accessor :fade

    def initialize(client, id)
      @client = client
      @id = id
      @path = "#{PATH}/#{@id}"
      @fade = 1
    end

    def data
      @client.get(@path)
    end

    def name
      data["9001"]
    end

    def on?
      get_control("5850") == 1
    end

    def on
      set_control({"5850" => 1})
    end

    def off
      set_control({"5850" => 0})
    end

    def toggle
      if on?
        off
      else
        on
      end
    end

    def dim
      (get_control("5851") / 254.0).round(2)
    end

    def dim=(value)
      set_control({"5851" => (value * 254).clamp(1, 254).to_i})
    end

    def color
      get_controls("5709", "5710")
    end

    def color=(arr)
      set_control({"5709" => arr[0], "5710" => arr[1]})
    end

    private

    def get_control(field)
      data["3311"]&.first&.dig(field) || 0
    end

    def get_controls(*fields)
      cdata = data["3311"]&.first
      fields.map { |f| cdata&.dig(f) || 0 }
    end

    def set_control(hash)
      hash["5712"] = fade * 10
      @client.put(@path, {"3311" => [hash]})
    end
  end
end
