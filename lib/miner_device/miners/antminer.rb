module MinerDevice
  class Antminer < BaseMiner
    DEFAULT_PORT = 4028

    def version
      raise BlockError, 'Invalid block' unless block_given?

      send_query('{"command":"version"}') do |v|
        if v.is_a?(Hash) && v['VERSION'].is_a?(Array) && v['VERSION'].first.is_a?(Hash)
          yield v['VERSION'].first['Type']
        else
          yield
        end
      end
    end

    def hashrate
      raise BlockError, 'Invalid block' unless block_given?

      send_query('{"command":"stats"}') do |data|
        unless data.is_a?(Hash) && data['STATS'].is_a?(Array) && data['STATS'].last.is_a?(Hash)
          yield HashrateResponse.new(success: false)
          return
        end

        ghs_av, ghs_5s = parse_ghs(data)
        yield HashrateResponse.new(success: true, state: data, ghs_av: ghs_av, ghs_5s: ghs_5s)
      end
    end

    private

    def parse_ghs(state)
      raw_stats = state['STATS'].last
      [parse_ghs_av(raw_stats), parse_ghs_5s(raw_stats)]
    end

    def parse_ghs_av(stats)
      stats['GHS av'].to_f
    rescue StandardError
      0.0
    end

    def parse_ghs_5s(stats)
      stats['GHS 5s'].to_f
    rescue StandardError
      0.0
    end
  end
end
