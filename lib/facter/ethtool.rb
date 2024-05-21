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

  def ethtool_result_to_h(cmd_output)
    result = {}
    current_subsection = result

    lines = cmd_output.split("\n")
    lines = lines.drop(1) # omit first line since it is a headline
    lines.each do |line|
      line = line.strip
      if line.end_with?(':')
        subsection_title = line.chop
        subsection_title = subsection_title.gsub(/ /, '_')
        result[subsection_title] = {}
        current_subsection = result[subsection_title]
      else
        parts = line.split(':')
        if parts.length == 2
          current_subsection[parts[0].strip.gsub(/ /, '_')] = parts[1].strip
        end
      end
    end

    result
  end

  setcode do
    result = {}
    Facter.value(:networking)['interfaces'].each do |interface, _|
      result[interface] = {}

      ring_buffer_results = ethtool("-g #{interface}")
      channel_results = ethtool("-l #{interface}")
      coalesce_results = ethtool("-c #{interface}")
      feature_results = ethtool("-k #{interface}")

      result[interface]['ring'] = ethtool_result_to_h(ring_buffer_results)
      result[interface]['channels'] = ethtool_result_to_h(channel_results)
      result[interface]['coalesce'] = ethtool_result_to_h(coalesce_results)
      result[interface]['features'] = ethtool_result_to_h(feature_results)
    end

    result
  end
end
