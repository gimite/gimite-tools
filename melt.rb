#!/usr/bin/env ruby

# License: Public Domain
# Author: Hiroshi Ichikawa (Gimite) <http://gimite.net/en/>

# Extracts files from archive in any format.

for path in ARGV
  case path
    when /\.tar\.gz$/i, /\.tgz$/i
      system("tar", "xvzf", path)
    when /\.tar\.bz2$/i
      system("tar", "xvjf", path)
    when /\.gz$/i
      system("gunzip", path)
    when /\.bz2$/i
      system("bunzip2", "-k", path)
    when /\.zip$/i
      system("unzip", path)
    else
      $stderr.puts("Unknown archive format: " + path)
      exit(1)
  end
  status = $?.to_i() / 256
  exit(status) if status != 0
end
