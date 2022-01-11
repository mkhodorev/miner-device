require 'fiber'
require 'json'
require 'eventmachine'

require 'miner_device/version'
require 'miner_device/base_miner'
require 'miner_device/connection'
require 'miner_device/hashrate_response'

require 'miner_device/miners/antminer'
require 'miner_device/miners/dragonmint_t1'

module MinerDevice
  class BlockError < StandardError; end

  class MinerNotFound < StandardError; end

  def self.discover(ip_address:)
    raise BlockError, 'Invalid block' unless block_given?

    # with Fiber implements the awaiting as in JS
    f = Fiber.new do
      miner_type = Antminer.discover(ip_address)
      miner_type = DragonmintT1.discover(ip_address) if miner_type.nil?
      yield miner_type
    end
    f.resume
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/CyclomaticComplexity
  def self.miner(device_type:)
    case device_type
    when 'antminer'
      Antminer
    when 'Bitmain_D3'
      Antminer
    when 'Bitmain_L3+'
      Antminer
    when 'Bitmain_S9'
      Antminer
    when 'Bitmain_S11'
      Antminer
    when 'Bitmain_T15'
      Antminer
    when 'Bitmain_S15'
      Antminer
    when 'DragonMint_T1'
      DragonmintT1
    else
      raise MinerNotFound, 'Miner Not Found'
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/CyclomaticComplexity
end
