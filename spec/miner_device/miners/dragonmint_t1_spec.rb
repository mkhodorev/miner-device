RSpec.describe MinerDevice::DragonmintT1 do
  describe '#hashrate' do
    let(:dragonmint_t1) { MinerDevice::DragonmintT1.new(ip_address: '127.0.0.1', port: 1234) }

    context 'when the block is not present' do
      it 'raises error "Invalid block"' do
        expect { dragonmint_t1.hashrate }.to raise_error(MinerDevice::BlockError, 'Invalid block')
      end
    end

    context 'when the miner is not available or not provide the correct data' do
      let(:result) { MinerDevice::HashrateResponse.new(success: false) }

      before do
        allow(dragonmint_t1).to receive(:send_query).and_yield(nil)
      end

      it 'returns failure result' do
        expect { |b| dragonmint_t1.hashrate(&b) }.to yield_with_args(result)
      end
    end

    context 'when the miner provides the correct data' do
      let(:data) { { 'DEVS' => [{ 'MHS av' => '500', 'MHS 5s' => '450' }, { 'MHS av' => '600', 'MHS 5s' => '750' }] } }
      let(:result) { MinerDevice::HashrateResponse.new(success: true, state: data, ghs_av: 1.1, ghs_5s: 1.2) }

      before do
        allow(dragonmint_t1).to receive(:send_query).and_yield(data)
      end

      it 'returns successful result' do
        expect { |b| dragonmint_t1.hashrate(&b) }.to yield_with_args(result)
      end
    end
  end

  describe '#version' do
    let(:dragonmint_t1) { MinerDevice::DragonmintT1.new(ip_address: '127.0.0.1', port: 1234) }

    context 'when the block is not present' do
      it 'raises error "Invalid block"' do
        expect { dragonmint_t1.version }.to raise_error(MinerDevice::BlockError, 'Invalid block')
      end
    end

    context 'when the miner is not available or not provide the correct data' do
      before do
        allow(dragonmint_t1).to receive(:send_query).and_yield(nil)
      end

      it 'returns failure result' do
        expect { |b| dragonmint_t1.version(&b) }.to yield_with_no_args
      end
    end

    context 'when the miner provides the correct data' do
      let(:data) { { 'DEVDETAILS' => [{ 'Driver' => 'DragonmintT1' }] } }
      let(:result) { 'DragonMint_T1' }

      before do
        allow(dragonmint_t1).to receive(:send_query).and_yield(data)
      end

      it 'returns successful result' do
        expect { |b| dragonmint_t1.version(&b) }.to yield_with_args(result)
      end
    end
  end
end
