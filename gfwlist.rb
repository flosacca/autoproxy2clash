#!/usr/bin/env ruby

MIRRORS = %w[
  https://gitlab.com/gfwlist/gfwlist/raw/master/gfwlist.txt
  https://pagure.io/gfwlist/raw/master/f/gfwlist.txt
  https://repo.or.cz/gfwlist.git/blob_plain/HEAD:/gfwlist.txt
  https://bitbucket.org/gfwlist/gfwlist/raw/HEAD/gfwlist.txt
  https://git.tuxfamily.org/gfwlist/gfwlist.git/plain/gfwlist.txt
  https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt
]

if __FILE__ == $0
  curl = MIRRORS.map { |url|
    "curl -sSm10 #{url}"
  }
  out = `( #{curl.join(' || ')} ) | ./autoproxy2clash.rb`
  list = out.lines(chomp: true)
  rules = [
    'IP-CIDR,127.0.0.0/8,DIRECT,no-resolve',
    'IP-CIDR,10.0.0.0/8,DIRECT,no-resolve',
    'IP-CIDR,172.16.0.0/12,DIRECT,no-resolve',
    'IP-CIDR,192.168.0.0/16,DIRECT,no-resolve',
    'IP-CIDR,100.64.0.0/10,DIRECT,no-resolve',
    'IP-CIDR6,::1/128,DIRECT,no-resolve',
    'IP-CIDR6,fc00::/7,DIRECT,no-resolve',
    'IP-CIDR6,fd00::/8,DIRECT,no-resolve',
    'IP-CIDR6,fe80::/10,DIRECT,no-resolve',
    *list,
    'GEOIP,CN,DIRECT',
    'MATCH,PROXY',
  ]
  puts 'rules:'
  rules.each do |rule|
    puts "- #{rule}"
  end
end
