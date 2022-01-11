module MinerDevice
  class Connection < EventMachine::Connection
    def initialize(*args)
      @completed = false
      @received_data = ''

      if args.first.is_a?(Hash)
        @command = args.first[:command]
        @on_data = args.first[:on_data]
        @response_timeout = args.first[:response_timeout]
      end

      super
    end

    def connection_completed
      @completed = true
    end

    def post_init
      start_response_timeout_timer
      send_data @command.to_s if @command
    end

    def start_response_timeout_timer
      @close_connection_timer = EventMachine::Timer.new(@response_timeout) do
        close_connection
      end
    end

    def receive_data(data)
      @received_data << data
    end

    def unbind
      @close_connection_timer.cancel

      if @completed
        @on_data.call(@received_data)
      else
        @on_data.call
      end
    end
  end
end
