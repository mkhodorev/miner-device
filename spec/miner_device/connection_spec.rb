RSpec.describe MinerDevice::Connection do
  describe '#unbind' do
    # rubocop:disable Lint/ConstantDefinitionInBlock
    class EMTimer
      def cancel; end
    end
    # rubocop:enable Lint/ConstantDefinitionInBlock

    before do
      allow_any_instance_of(MinerDevice::Connection).to receive(:start_response_timeout_timer)
    end

    context('when data is successfully received') do
      let(:connection) { MinerDevice::Connection.new(nil) }

      before do
        connection.instance_variable_set(:@close_connection_timer, EMTimer.new)
      end

      it 'calls "on_data" with received data' do
        on_data = proc do |data|
          expect(data).to eq('test_data')
        end
        connection.instance_variable_set(:@on_data, on_data)
        connection.receive_data('test_data')
        connection.connection_completed
        connection.unbind
      end
    end

    context('when data is not successfully received') do
      let(:connection) { MinerDevice::Connection.new(nil) }

      before do
        connection.instance_variable_set(:@close_connection_timer, EMTimer.new)
      end

      it 'calls "on_data" with nil' do
        on_data = proc do |data|
          expect(data).to be_nil
        end
        connection.instance_variable_set(:@on_data, on_data)
        connection.receive_data('test_data')
        connection.unbind
      end
    end
  end
end
