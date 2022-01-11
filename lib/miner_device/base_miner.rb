module MinerDevice
  class BaseMiner
    class << self
      def discover(ip_address)
        current_fiber = Fiber.current

        miner = new(ip_address: ip_address, port: DEFAULT_PORT)
        # block is called by EM after receiving the version from the miner
        miner.version do |ver|
          current_fiber.resume(ver)
        end

        # Yields control back to the context that resumed the fiber
        # and waits for the next resume
        Fiber.yield
      end
    end

    def hashrate(&_callback)
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    def version(&_callback)
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    def initialize(ip_address:, port:, connection_timeout: 3, response_timeout: 3)
      @ip_address = ip_address
      @port = port.to_i
      @connection_timeout = connection_timeout
      @response_timeout = response_timeout
      @connection_completed = false
      @connection = nil
    end

    private

    def parse_json(data)
      return if data.nil?

      json_string = data.gsub('}{', '},{').gsub("\x00", '')
      JSON.parse(json_string)
    rescue StandardError
      nil
    end

    def send_query(command)
      raise 'Invalid block' unless block_given?

      on_data = proc do |d|
        yield parse_json(d)
      end

      @connection = EventMachine.connect(@ip_address,
                                         @port,
                                         Connection,
                                         command: command,
                                         response_timeout: @response_timeout,
                                         on_data: on_data) do
        c.pending_connect_timeout = @connection_timeout
      end
    end
  end
end
