#!/bin/bash

echo 'rules:'
{
  cat lan.txt
  curl -sSL https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt | ./autoproxy2clash.rb
  cat final.txt
} | sed 's/^/- /'
