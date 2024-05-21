# frozen_string_literal: true

require 'spec_helper'
require 'facter'
require 'facter/ethtool'

describe :ethtool, type: :fact do
  subject(:fact) { Facter.fact(:ethtool) }

  ethtool_k = <<~EOT
    Features for eno1:
    rx-checksumming: on [fixed]
    tx-checksumming: on
      tx-checksum-ipv4: on
      tx-checksum-ip-generic: off [fixed]
      tx-checksum-ipv6: on
      tx-checksum-fcoe-crc: off [fixed]
      tx-checksum-sctp: off [fixed]
    scatter-gather: on
      tx-scatter-gather: on
      tx-scatter-gather-fraglist: off [fixed]
    tcp-segmentation-offload: on
      tx-tcp-segmentation: on
      tx-tcp-ecn-segmentation: off [fixed]
      tx-tcp-mangleid-segmentation: off
      tx-tcp6-segmentation: on
    generic-segmentation-offload: on
    generic-receive-offload: on
    large-receive-offload: off [fixed]
    rx-vlan-offload: off [fixed]
    tx-vlan-offload: off [fixed]
    ntuple-filters: off [fixed]
    receive-hashing: off [fixed]
    highdma: on
    rx-vlan-filter: off [fixed]
    vlan-challenged: off [fixed]
    tx-lockless: off [fixed]
    netns-local: on [fixed]
    tx-gso-robust: off [fixed]
    tx-fcoe-segmentation: off [fixed]
    tx-gre-segmentation: off [fixed]
    tx-gre-csum-segmentation: off [fixed]
    tx-ipxip4-segmentation: off [fixed]
    tx-ipxip6-segmentation: off [fixed]
    tx-udp_tnl-segmentation: off [fixed]
    tx-udp_tnl-csum-segmentation: off [fixed]
    tx-gso-partial: off [fixed]
    tx-tunnel-remcsum-segmentation: off [fixed]
    tx-sctp-segmentation: off [fixed]
    tx-esp-segmentation: off [fixed]
    tx-udp-segmentation: off [fixed]
    tx-gso-list: off [fixed]
    fcoe-mtu: off [fixed]
    tx-nocache-copy: off
    loopback: off [fixed]
    rx-fcs: off [fixed]
    rx-all: off [fixed]
    tx-vlan-stag-hw-insert: off [fixed]
    rx-vlan-stag-hw-parse: off [fixed]
    rx-vlan-stag-filter: off [fixed]
    l2-fwd-offload: off [fixed]
    hw-tc-offload: off [fixed]
    esp-hw-offload: off [fixed]
    esp-tx-csum-hw-offload: off [fixed]
    rx-udp_tunnel-port-offload: off [fixed]
    tls-hw-tx-offload: off [fixed]
    tls-hw-rx-offload: off [fixed]
    rx-gro-hw: off [fixed]
    tls-hw-record: off [fixed]
    rx-gro-list: off
    macsec-hw-offload: off [fixed]
    rx-udp-gro-forwarding: off
    hsr-tag-ins-offload: off [fixed]
    hsr-tag-rm-offload: off [fixed]
    hsr-fwd-offload: off [fixed]
    hsr-dup-offload: off [fixed]
  EOT

  ethtool_c = <<~EOT
    Coalesce parameters for eno1:
    Adaptive RX: n/a  TX: n/a
    stats-block-usecs:	n/a
    sample-interval:	n/a
    pkt-rate-low:		n/a
    pkt-rate-high:		n/a

    rx-usecs:	3
    rx-frames:	n/a
    rx-usecs-irq:	n/a
    rx-frames-irq:	n/a

    tx-usecs:	n/a
    tx-frames:	n/a
    tx-usecs-irq:	n/a
    tx-frames-irq:	n/a

    rx-usecs-low:	n/a
    rx-frame-low:	n/a
    tx-usecs-low:	n/a
    tx-frame-low:	n/a

    rx-usecs-high:	n/a
    rx-frame-high:	n/a
    tx-usecs-high:	n/a
    tx-frame-high:	n/a

    CQE mode RX: n/a  TX: n/a

    tx-aggr-max-bytes:	n/a
    tx-aggr-max-frames:	n/a
    tx-aggr-time-usecs	n/a
  EOT

  ethtool_g = <<~EOT
    Ring parameters for eno1:
    Pre-set maximums:
    RX:			4096
    RX Mini:		n/a
    RX Jumbo:		n/a
    TX:			4096
    TX push buff len:	n/a
    Current hardware settings:
    RX:			256
    RX Mini:		n/a
    RX Jumbo:		n/a
    TX:			256
    RX Buf Len:		n/a
    CQE Size:		n/a
    TX Push:		off
    RX Push:		n/a
    TX push buff len:	n/a
    TCP data split:		n/a
  EOT

  ethtool_l = <<~EOT
    Channel parameters for eno1:
    Pre-set maximums:
    RX:		n/a
    TX:		n/a
    Other:		1
    Combined:	63
    Current hardware settings:
    RX:		n/a
    TX:		n/a
    Other:		1
    Combined:	8
  EOT

  before :each do
    # perform any action that should be run before every test
    Facter.clear
    require 'facter/ethtool'
    allow(Facter::Core::Execution).to receive(:which).and_call_original
    allow(Facter::Core::Execution).to receive(:which).with('ethtool').and_return('/usr/bin/ethtool')
    allow(Facter.fact(:networking)).to receive(:value).and_return(
      {
        'interfaces' => {
          'eno1' => {},
        }
      },
    )
    allow(Facter::Core::Execution).to receive(:execute).and_call_original
    allow(Facter::Core::Execution).to receive(:execute).with('ethtool -k eno1').and_return(ethtool_k)
    allow(Facter::Core::Execution).to receive(:execute).with('ethtool -l eno1').and_return(ethtool_l)
    allow(Facter::Core::Execution).to receive(:execute).with('ethtool -c eno1').and_return(ethtool_c)
    allow(Facter::Core::Execution).to receive(:execute).with('ethtool -g eno1').and_return(ethtool_g)
  end

  it 'returns a value' do
    expect(fact.value).to eq(
                            {
                              'eno1' => {
                                'ring' => {
                                  'Current_hardware_settings' => {
                                    'CQE_Size' => 'n/a',
                                    'RX' => '256',
                                    'RX_Buf_Len' => 'n/a',
                                    'RX_Jumbo' => 'n/a',
                                    'RX_Mini' => 'n/a',
                                    'RX_Push' => 'n/a',
                                    'TCP_data_split' => 'n/a',
                                    'TX' => '256',
                                    'TX_Push' => 'off',
                                    'TX_push_buff_len' => 'n/a'
                                  },
                                  'Pre-set_maximums' => {
                                    'RX' => '4096',
                                    'RX_Jumbo' => 'n/a',
                                    'RX_Mini' => 'n/a',
                                    'TX' => '4096',
                                    'TX_push_buff_len' => 'n/a'
                                  }
                                },
                                'channels' => {
                                  'Current_hardware_settings' => {
                                    'Combined' => '8',
                                    'Other' => '1',
                                    'RX' => 'n/a',
                                    'TX' => 'n/a'
                                  },
                                  'Pre-set_maximums' => {
                                    'Combined' => '63',
                                    'Other' => '1',
                                    'RX' => 'n/a',
                                    'TX' => 'n/a'
                                  }
                                },
                                'coalesce' => {
                                  'pkt-rate-high' => 'n/a',
                                  'pkt-rate-low' => 'n/a',
                                  'rx-frame-high' => 'n/a',
                                  'rx-frame-low' => 'n/a',
                                  'rx-frames' => 'n/a',
                                  'rx-frames-irq' => 'n/a',
                                  'rx-usecs' => '3',
                                  'rx-usecs-high' => 'n/a',
                                  'rx-usecs-irq' => 'n/a',
                                  'rx-usecs-low' => 'n/a',
                                  'sample-interval' => 'n/a',
                                  'stats-block-usecs' => 'n/a',
                                  'tx-aggr-max-bytes' => 'n/a',
                                  'tx-aggr-max-frames' => 'n/a',
                                  'tx-frame-high' => 'n/a',
                                  'tx-frame-low' => 'n/a',
                                  'tx-frames' => 'n/a',
                                  'tx-frames-irq' => 'n/a',
                                  'tx-usecs' => 'n/a',
                                  'tx-usecs-high' => 'n/a',
                                  'tx-usecs-irq' => 'n/a',
                                  'tx-usecs-low' => 'n/a'
                                },
                                'features' => {
                                  'esp-hw-offload' => 'off [fixed]',
                                  'esp-tx-csum-hw-offload' => 'off [fixed]',
                                  'fcoe-mtu' => 'off [fixed]',
                                  'generic-receive-offload' => 'on',
                                  'generic-segmentation-offload' => 'on',
                                  'highdma' => 'on',
                                  'hsr-dup-offload' => 'off [fixed]',
                                  'hsr-fwd-offload' => 'off [fixed]',
                                  'hsr-tag-ins-offload' => 'off [fixed]',
                                  'hsr-tag-rm-offload' => 'off [fixed]',
                                  'hw-tc-offload' => 'off [fixed]',
                                  'l2-fwd-offload' => 'off [fixed]',
                                  'large-receive-offload' => 'off [fixed]',
                                  'loopback' => 'off [fixed]',
                                  'macsec-hw-offload' => 'off [fixed]',
                                  'netns-local' => 'on [fixed]',
                                  'ntuple-filters' => 'off [fixed]',
                                  'receive-hashing' => 'off [fixed]',
                                  'rx-all' => 'off [fixed]',
                                  'rx-checksumming' => 'on [fixed]',
                                  'rx-fcs' => 'off [fixed]',
                                  'rx-gro-hw' => 'off [fixed]',
                                  'rx-gro-list' => 'off',
                                  'rx-udp-gro-forwarding' => 'off',
                                  'rx-udp_tunnel-port-offload' => 'off [fixed]',
                                  'rx-vlan-filter' => 'off [fixed]',
                                  'rx-vlan-offload' => 'off [fixed]',
                                  'rx-vlan-stag-filter' => 'off [fixed]',
                                  'rx-vlan-stag-hw-parse' => 'off [fixed]',
                                  'scatter-gather' => 'on',
                                  'tcp-segmentation-offload' => 'on',
                                  'tls-hw-record' => 'off [fixed]',
                                  'tls-hw-rx-offload' => 'off [fixed]',
                                  'tls-hw-tx-offload' => 'off [fixed]',
                                  'tx-checksum-fcoe-crc' => 'off [fixed]',
                                  'tx-checksum-ip-generic' => 'off [fixed]',
                                  'tx-checksum-ipv4' => 'on',
                                  'tx-checksum-ipv6' => 'on',
                                  'tx-checksum-sctp' => 'off [fixed]',
                                  'tx-checksumming' => 'on',
                                  'tx-esp-segmentation' => 'off [fixed]',
                                  'tx-fcoe-segmentation' => 'off [fixed]',
                                  'tx-gre-csum-segmentation' => 'off [fixed]',
                                  'tx-gre-segmentation' => 'off [fixed]',
                                  'tx-gso-list' => 'off [fixed]',
                                  'tx-gso-partial' => 'off [fixed]',
                                  'tx-gso-robust' => 'off [fixed]',
                                  'tx-ipxip4-segmentation' => 'off [fixed]',
                                  'tx-ipxip6-segmentation' => 'off [fixed]',
                                  'tx-lockless' => 'off [fixed]',
                                  'tx-nocache-copy' => 'off',
                                  'tx-scatter-gather' => 'on',
                                  'tx-scatter-gather-fraglist' => 'off [fixed]',
                                  'tx-sctp-segmentation' => 'off [fixed]',
                                  'tx-tcp-ecn-segmentation' => 'off [fixed]',
                                  'tx-tcp-mangleid-segmentation' => 'off',
                                  'tx-tcp-segmentation' => 'on',
                                  'tx-tcp6-segmentation' => 'on',
                                  'tx-tunnel-remcsum-segmentation' => 'off [fixed]',
                                  'tx-udp-segmentation' => 'off [fixed]',
                                  'tx-udp_tnl-csum-segmentation' => 'off [fixed]',
                                  'tx-udp_tnl-segmentation' => 'off [fixed]',
                                  'tx-vlan-offload' => 'off [fixed]',
                                  'tx-vlan-stag-hw-insert' => 'off [fixed]',
                                  'vlan-challenged' => 'off [fixed]'
                                }
                              },
                            },
                          )
  end
end
