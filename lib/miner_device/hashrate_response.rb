module MinerDevice
  class HashrateResponse
    attr_reader :success, :state, :hashrate_values

    def initialize(success:, state: nil, ghs_av: nil, ghs_5s: nil)
      @success = success
      @state = state
      @ghs_av = ghs_av
      @ghs_5s = ghs_5s
      generate_hashrate_values
    end

    def to_json(*_args)
      if @success
        { success: true, state: @state, hashrateValues: @hashrate_values }.to_json
      else
        { success: false }.to_json
      end
    end

    def ==(other)
      other.class == self.class &&
        other.success == success &&
        other.state == state &&
        other.hashrate_values == hashrate_values
    end

    private

    def generate_hashrate_values
      @hashrate_values = { ghsAv: @ghs_av, ghs5s: @ghs_5s }
    end
  end
end
