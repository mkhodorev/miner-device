module MinerDevice
  class DragonmintT1 < BaseMiner
    DEFAULT_PORT = 4028

    def version
      raise BlockError, 'Invalid block' unless block_given?

      send_query('{"command":"devdetails"}') do |v|
        if v.is_a?(Hash) &&
           v['DEVDETAILS'].is_a?(Array) &&
           v['DEVDETAILS'].first.is_a?(Hash) &&
           v['DEVDETAILS'].first['Driver'] == 'DragonmintT1'
          yield 'DragonMint_T1'
        else
          yield
        end
      end
    end

    def hashrate
      raise BlockError, 'Invalid block' unless block_given?

      send_query('{"command":"devs"}') do |data|
        unless data.is_a?(Hash) && data.key?('DEVS') && data['DEVS'].is_a?(Array)
          yield HashrateResponse.new(success: false)
          return
        end

        ghs_av, ghs_5s = parse_ghs(data['DEVS'])
        yield HashrateResponse.new(success: true, state: data, ghs_av: ghs_av, ghs_5s: ghs_5s)
      end
    end

    private

    def parse_ghs(state)
      mhs_av, mhs_5s = calculate_mhs(state)

      [mhs_to_ghs(mhs_av), mhs_to_ghs(mhs_5s)]
    end

    def calculate_mhs(state)
      mhs_av = 0.0
      mhs_5s = 0.0

      state.each do |dev|
        mhs_av += dev['MHS av'].to_f
        mhs_5s += dev['MHS 5s'].to_f
      end

      [mhs_av, mhs_5s]
    end

    def mhs_to_ghs(mhs)
      (mhs / 1000).round(2)
    rescue StandardError
      0.0
    end
  end
end
