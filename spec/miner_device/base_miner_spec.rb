RSpec.describe MinerDevice::BaseMiner do
  describe '.discover' do
    before do
      stub_const('DEFAULT_PORT', 1)
    end

    def discover
      f = Fiber.new do
        miner = MinerDevice::BaseMiner.discover('127.0.0.1')
        EM.stop
        yield miner
      end
      f.resume
    end

    context 'when the miner is discovered' do
      before do
        allow_any_instance_of(MinerDevice::BaseMiner).to receive(:version) do |&block|
          EM.next_tick { block.call 'my_miner' }
        end
      end

      it 'returns "my_miner"' do
        EM.run do
          discover { |miner| expect(miner).to eq('my_miner') }
        end
      end
    end

    context 'when the miner is not discovered' do
      before do
        allow_any_instance_of(MinerDevice::BaseMiner).to receive(:version) do |&block|
          EM.next_tick { block.call }
        end
      end

      it 'returns nil' do
        EM.run do
          discover { |miner| expect(miner).to be_nil }
        end
      end
    end
  end

  describe('#parse_json') do
    let(:miner) { MinerDevice::BaseMiner.new(ip_address: '127.0.0.1', port: 1234) }

    context 'parse with valid JSON' do
      let(:raw_json) { '[{"val1":1}{"val2":2}]' }
      let(:result) { [{ 'val1' => 1 }, { 'val2' => 2 }] }

      it { expect(miner.send(:parse_json, raw_json)).to eq(result) }
    end

    context 'parse with invalid JSON' do
      let(:raw_json) { '[{"val1":1}"val2":2}]' }

      it { expect(miner.send(:parse_json, raw_json)).to be_nil }
    end
  end
end
