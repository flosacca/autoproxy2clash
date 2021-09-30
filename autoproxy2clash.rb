#!/usr/bin/env ruby

# AutoProxy is designed to match the full URL.
# Rule syntax:
#   'pattern' (no prefix): HTTP URL (not HTTPS) containing 'pattern'.
#   '|pattern': URL starting with 'pattern' (including scheme).
#   '||pattern': domain name ending with 'pattern'.
#   '/regex/': URL matching 'regex' as (javascript) regex.
#   '@@rule': negates 'rule'.
# Wildcard character '*' is allowed in 'pattern'.
# Lines starting with '!' are ignored.

# Clash is not designed to handle the full URL.
# It can do no more matching than the following for a URL:
# 'DOMAIN': a full domain name.
# 'DOMAIN-SUFFIX': a suffix of a domain name.
# 'DOMAIN-KEYWORD': a substring of a domain name.

require 'base64'

if __FILE__ == $0
  input = ARGF.read
  unless input =~ %r{[^[:alnum:]+/=\s]}
    input = Base64.decode64(input)
  end

  result = Hash.new{ |h, k| h[k] = [] }

  input.each_line(chomp: true) do |rule|
    next if rule =~ /^(\s*$|!|\[)/

    # Regex is not supported
    next if rule.start_with?('/')

    # Skip negative rules
    next if rule.start_with?('@@')

    # Discard scheme
    rule.gsub!(/https?:\/\//, '')

    # Discard path
    rule.gsub!(/\/.*/, '')

    if pattern = rule[/^(.*\*[^.]*\.|\|\|)(.+)$/, 2]
      result[:suffix] << pattern
      next
    end

    if pattern = rule[/^\|(.+\.[a-zA-Z].+)$/, 1]
      result[:full] << pattern
      next
    end

    if pattern = rule[/^(?=.*\.[a-zA-Z])[a-zA-Z0-9.-]+$/]
      result[:keyword] << pattern
      next
    end
  end

  result.transform_values!(&:uniq!)

  # Remove keyword rules similar with suffix rules
  result[:keyword].reject! do |pattern|
    result[:suffix].any?{ |s|
      pattern.end_with?(s)
    }
  end

  result[:full].reject! do |pattern|
    result[:suffix].any?{ |s|
      pattern.end_with?(s)
    } || result[:keyword].any?{ |s|
      pattern.include?(s)
    }
  end

  result[:full].each do |pattern|
    print "DOMAIN,#{pattern},PROXY\n"
  end

  result[:suffix].each do |pattern|
    print "DOMAIN-SUFFIX,#{pattern},PROXY\n"
  end

  result[:keyword].each do |pattern|
    print "DOMAIN-KEYWORD,#{pattern},PROXY\n"
  end
end
