# puppet-ethtool_facts

Custom fact containing ethtool output for every interface.

## Table of Contents

1. [Description](#description)
1. [Setup](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with ethtool_facts](#beginning-with-ethtool_facts)
1. [Usage](#usage)
1. [Configuration](#configuration)
    * [Physical Interface Filtering](#physical-interface-filtering)

## Description

When attempting to automate NIC tuning via Puppet the built-in facts are a good start but not sufficient.
A good example is channel tuning: If you want to set the NIC channels to the maximum value you need to know what the maximum value is.
On CLI you can detect that via `ethtool -l <interface>`. 
This module takes on the task of reading the output of this and several other ethtool flags to make that information available at catalog compile time.
This module provides ethtool information for all network interfaces by default, with an option to filter for physical interfaces only.

## Setup

### Setup Requirements

`ethtool` must be installed. If not, then the fact will be empty. 
You need to ensure that the binary is present on you system.

### Beginning with ethtool_facts

The very basic steps needed for a user to get the module up and running. This
can include setup steps, if necessary, or it can be an example of the most basic
use of the module.

## Usage

Just install this module and `puppet facts | jq '.values.ethtool'` should show something like this:

```json
{
  "eno1": {
    "driver": {
      "driver": "ixgbe",
      "version": "6.5.0-35-generic",
      "firmware-version": "0x80001733, 1.3105.0",
      "expansion-rom-version": "",
      "bus-info": "0000:61:00.0",
      "supports-statistics": "yes",
      "supports-test": "yes",
      "supports-eeprom-access": "yes",
      "supports-register-dump": "yes",
      "supports-priv-flags": "yes"
    },
    "ring": {
      "Pre-set_maximums": {
        "RX": "4096",
        "RX_Mini": "n/a",
        "RX_Jumbo": "n/a",
        "TX": "4096"
      },
      "Current_hardware_settings": {
        "RX": "4096",
        "RX_Mini": "n/a",
        "RX_Jumbo": "n/a",
        "TX": "4096"
      }
    },
    "channels": {
      "Pre-set_maximums": {
        "RX": "n/a",
        "TX": "n/a",
        "Other": "1",
        "Combined": "63"
      },
      "Current_hardware_settings": {
        "RX": "n/a",
        "TX": "n/a",
        "Other": "1",
        "Combined": "8"
      }
    },
    "coalesce": {
      "stats-block-usecs": "n/a",
      "sample-interval": "n/a",
      "pkt-rate-low": "n/a",
      "pkt-rate-high": "n/a",
      "rx-usecs": "1",
      "rx-frames": "n/a",
      "rx-usecs-irq": "n/a",
      "rx-frames-irq": "n/a",
      "tx-usecs": "0",
      "tx-frames": "n/a",
      "tx-usecs-irq": "n/a",
      "tx-frames-irq": "n/a",
      "rx-usecs-low": "n/a",
      "rx-frame-low": "n/a",
      "tx-usecs-low": "n/a",
      "tx-frame-low": "n/a",
      "rx-usecs-high": "n/a",
      "rx-frame-high": "n/a",
      "tx-usecs-high": "n/a",
      "tx-frame-high": "n/a"
    },
    "features": {
      "rx-checksumming": "on",
      "tx-checksumming": "on",
      "tx-checksum-ipv4": "off [fixed]",
      "tx-checksum-ip-generic": "on",
      "tx-checksum-ipv6": "off [fixed]",
      "tx-checksum-fcoe-crc": "on [fixed]",
      "tx-checksum-sctp": "on",
      "scatter-gather": "on",
      "tx-scatter-gather": "on",
      "tx-scatter-gather-fraglist": "off [fixed]",
      "tcp-segmentation-offload": "on",
      "tx-tcp-segmentation": "on",
      "tx-tcp-ecn-segmentation": "off [fixed]",
      "tx-tcp-mangleid-segmentation": "off",
      "tx-tcp6-segmentation": "on",
      "generic-segmentation-offload": "on",
      "generic-receive-offload": "on",
      "large-receive-offload": "off",
      "rx-vlan-offload": "on",
      "tx-vlan-offload": "on",
      "ntuple-filters": "off",
      "receive-hashing": "on",
      "highdma": "on [fixed]",
      "rx-vlan-filter": "on",
      "vlan-challenged": "off [fixed]",
      "tx-lockless": "off [fixed]",
      "netns-local": "off [fixed]",
      "tx-gso-robust": "off [fixed]",
      "tx-fcoe-segmentation": "on [fixed]",
      "tx-gre-segmentation": "on",
      "tx-gre-csum-segmentation": "on",
      "tx-ipxip4-segmentation": "on",
      "tx-ipxip6-segmentation": "on",
      "tx-udp_tnl-segmentation": "on",
      "tx-udp_tnl-csum-segmentation": "on",
      "tx-gso-partial": "on",
      "tx-tunnel-remcsum-segmentation": "off [fixed]",
      "tx-sctp-segmentation": "off [fixed]",
      "tx-esp-segmentation": "on",
      "tx-udp-segmentation": "on",
      "tx-gso-list": "off [fixed]",
      "fcoe-mtu": "off [fixed]",
      "tx-nocache-copy": "off",
      "loopback": "off [fixed]",
      "rx-fcs": "off [fixed]",
      "rx-all": "off",
      "tx-vlan-stag-hw-insert": "off [fixed]",
      "rx-vlan-stag-hw-parse": "off [fixed]",
      "rx-vlan-stag-filter": "off [fixed]",
      "l2-fwd-offload": "off",
      "hw-tc-offload": "off",
      "esp-hw-offload": "on",
      "esp-tx-csum-hw-offload": "on",
      "rx-udp_tunnel-port-offload": "on",
      "tls-hw-tx-offload": "off [fixed]",
      "tls-hw-rx-offload": "off [fixed]",
      "rx-gro-hw": "off [fixed]",
      "tls-hw-record": "off [fixed]",
      "rx-gro-list": "off",
      "macsec-hw-offload": "off [fixed]",
      "rx-udp-gro-forwarding": "off",
      "hsr-tag-ins-offload": "off [fixed]",
      "hsr-tag-rm-offload": "off [fixed]",
      "hsr-fwd-offload": "off [fixed]",
      "hsr-dup-offload": "off [fixed]"
    },
    "time_stamping": {
      "Capabilities": {
        "hardware-raw-clock": true,
        "hardware-receive": true,
        "hardware-transmit": true,
        "software-receive": true,
        "software-system-clock": true,
        "software-transmit": true
      },
      "Hardware_Receive_Filter_Modes": {
        "none": true,
        "ptpv1-l4-event": true,
        "ptpv2-l2-event": true,
        "ptpv2-l4-event": true
      },
      "Hardware_Transmit_Timestamp_Modes": {
        "off": true,
        "on": true
      },
      "PTP_Hardware_Clock": "0"
    }
  }
}
```
## Configuration

### Physical Interface Filtering

Set the `ethtool_physical_only` fact to `true` to limit ethtool output to only physical network interfaces:

```bash
export FACTER_ethtool_physical_only=true
```

This is useful when you want to exclude virtual interfaces like bridges or bonds from the ethtool output.