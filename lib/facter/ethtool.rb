# frozen_string_literal: true

Facter.add(:ethtool) do
  confine :kernel do |value|
    value.casecmp('linux').zero?
  end
  confine do
    !Facter::Core::Execution.which('ethtool').nil?
  end

  def ethtool(args)
    Facter::Core::Execution.execute("ethtool #{args}")
  end

  def ethtool_result_to_h(cmd_output, has_no_headlines = false)
    result = {}
    current_subsection = result

    lines = cmd_output.split("\n")
    lines = has_no_headlines ? lines : lines.drop(1) # omit first line if it is a headline
    lines.each do |line|
      line = line.strip
      if line.end_with?(':')
        if has_no_headlines # case 1: key with empty value
          current_subsection[line.tr(':', '')] = ''
        else # case 2: headline which becomes key to a sub-hash
          subsection_title = line.chop
          subsection_title = subsection_title.tr(' ', '_')
          result[subsection_title] = {}
          current_subsection = result[subsection_title]
        end
      else # case 3: normal key-value pair
        parts = line.split(%r{:\s+})
        if parts.length == 2
          current_subsection[parts[0].strip.tr(' ', '_')] = parts[1].strip
        end
      end
    end

    result
  end

  setcode do
    result = {}
    Facter.value(:networking)['interfaces'].each do |interface, _|
      result[interface] = {}

      driver_results = ethtool("-i #{interface}")
      ring_buffer_results = ethtool("-g #{interface}")
      channel_results = ethtool("-l #{interface}")
      coalesce_results = ethtool("-c #{interface}")
      feature_results = ethtool("-k #{interface}")

      result[interface]['driver'] = ethtool_result_to_h(driver_results, true)
      result[interface]['ring'] = ethtool_result_to_h(ring_buffer_results)
      result[interface]['channels'] = ethtool_result_to_h(channel_results)
      result[interface]['coalesce'] = ethtool_result_to_h(coalesce_results)
      result[interface]['features'] = ethtool_result_to_h(feature_results)
    end

    result
  end
end
