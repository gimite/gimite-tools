#!/usr/bin/env ruby

# License: Public Domain
# Author: Hiroshi Ichikawa (Gimite) <http://gimite.net/en/>

# Outputs disk consumption breakdown of current directory, sorted by size,
# with ratio and human readable size.

def human(n)
  for u in [" ", "K", "M", "G", "T"]
    return "%6.1f%s" % [n, u] if n < 1024
    n /= 1024.0
  end
end

file_names = Dir["*"] + Dir[".*"] - [".", ".."]
command = "du -s -- %s" %
    file_names.map(){ |s| "'%s'" % s.gsub(/'/){ "'\\''" } }.join(" ")
data =
  `#{command}`.chomp().split(/\n/).
  map(){ |s| (b, f) = s.split(/\s+/); [b.to_i(), f] }.
  sort_by(){ |b, f| -b }

total = data.map(){ |b, f| b }.inject(:+)
for b, f in [[total, "*TOTAL*"]] + data
  printf("%3d%%  %s  %s\n", 100.0 * b / total, human(b * 1024), f)
end
