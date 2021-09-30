# AutoProxy2Clash

## Description

Convert rule list from AutoProxy format (e.g. GFWList) to Clash format.

Note: GFWList may not be the best choice. Consider [subconverter](https://github.com/tindy2013/subconverter).

## Usage

Get GFWList:
```
./gfwlist.rb > rules.yml
```

Convert local file (output raw strings):
```
./autoproxy2clash.rb [LIST-FILE]
```
