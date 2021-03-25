#!/bin/bash

echo 'rules:'
{
  cat lan.txt
  {
    curl -sSm10 https://gitlab.com/gfwlist/gfwlist/raw/master/gfwlist.txt \
      || curl -sSm10 https://pagure.io/gfwlist/raw/master/f/gfwlist.txt \
      || curl -sSm10 https://repo.or.cz/gfwlist.git/blob_plain/HEAD:/gfwlist.txt \
      || curl -sSm10 https://bitbucket.org/gfwlist/gfwlist/raw/HEAD/gfwlist.txt \
      || curl -sSm10 https://git.tuxfamily.org/gfwlist/gfwlist.git/plain/gfwlist.txt \
      || curl -sSm10 https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt
  } | ./autoproxy2clash.rb
  cat final.txt
} | sed 's/^/- /'
