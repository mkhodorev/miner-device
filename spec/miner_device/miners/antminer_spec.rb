RSpec.describe MinerDevice::Antminer do
  describe '#hashrate' do
    let(:antminer) { MinerDevice::Antminer.new(ip_address: '127.0.0.1', port: 1234) }

    context 'when the block is not present' do
      it 'raises error "Invalid block"' do
        expect { antminer.hashrate }.to raise_error(MinerDevice::BlockError, 'Invalid block')
      end
    end

    context 'when the miner is not available or not provide the correct data' do
      let(:result) { MinerDevice::HashrateResponse.new(success: false) }

      before do
        allow(antminer).to receive(:send_query).and_yield(nil)
      end

      it 'returns failure result' do
        expect { |b| antminer.hashrate(&b) }.to yield_with_args(result)
      end
    end

    context 'when the miner provides the correct data' do
      let(:data) { { 'STATS' => [{ 'a' => '1' }, { 'GHS av' => '1.1', 'GHS 5s' => '2.2' }] } }
      let(:result) { MinerDevice::HashrateResponse.new(success: true, state: data, ghs_av: 1.1, ghs_5s: 2.2) }

      before do
        allow(antminer).to receive(:send_query).and_yield(data)
      end

      it 'returns successful result' do
        expect { |b| antminer.hashrate(&b) }.to yield_with_args(result)
      end
    end
  end

  describe '#version' do
    let(:antminer) { MinerDevice::Antminer.new(ip_address: '127.0.0.1', port: 1234) }

    context 'when the block is not present' do
      it 'raises error "Invalid block"' do
        expect { antminer.version }.to raise_error(MinerDevice::BlockError, 'Invalid block')
      end
    end

    context 'when the miner is not available or not provide the correct data' do
      before do
        allow(antminer).to receive(:send_query).and_yield(nil)
      end

      it 'returns failure result' do
        expect { |b| antminer.version(&b) }.to yield_with_no_args
      end
    end

    context 'when the miner provides the correct data' do
      let(:data) { { 'VERSION' => [{ 'Type' => 'antminer' }] } }
      let(:result) { 'antminer' }

      before do
        allow(antminer).to receive(:send_query).and_yield(data)
      end

      it 'returns successful result' do
        expect { |b| antminer.version(&b) }.to yield_with_args(result)
      end
    end
  end
end
