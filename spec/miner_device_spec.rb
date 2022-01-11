RSpec.describe MinerDevice do
  it 'has a version number' do
    expect(MinerDevice::VERSION).not_to be nil
  end

  describe '.discover' do
    context 'when the block is not present' do
      it 'raises error "Invalid block"' do
        expect do
          MinerDevice.discover(ip_address: '127.0.0.1')
        end.to raise_error(MinerDevice::BlockError, 'Invalid block')
      end
    end

    context 'when the miner is not discovered' do
      before do
        allow(MinerDevice::BaseMiner).to receive(:discover)
      end

      it 'calls block with "nil"' do
        expect { |b| MinerDevice.discover(ip_address: '127.0.0.1', &b) }.to yield_with_args(nil)
      end
    end

    context 'when the miner is discovered' do
      before do
        allow(MinerDevice::BaseMiner).to receive(:discover) { 'antminer' }
      end

      it 'calls block with "antminer"' do
        expect { |b| MinerDevice.discover(ip_address: '127.0.0.1', &b) }.to yield_with_args('antminer')
      end
    end
  end

  describe '.miner' do
    context 'when the miner is not found' do
      it 'raises error "Miner Not Found"' do
        expect do
          MinerDevice.miner(device_type: '')
        end.to raise_error(MinerDevice::MinerNotFound, 'Miner Not Found')
      end
    end

    context 'when the miner is found' do
      it 'returns the miner class' do
        expect(MinerDevice.miner(device_type: 'antminer')).to eq(MinerDevice::Antminer)
      end
    end
  end
end
