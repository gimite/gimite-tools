#!/usr/bin/env ruby

# License: Public Domain
# Author: Hiroshi Ichikawa (Gimite) <http://gimite.net/en/>

# Moves files to ~/.trash .

require "fileutils"
require "date"


paths_by_dir = {}
for path in ARGV
  dir = File.dirname(path)
  paths_by_dir[dir] ||= []
  paths_by_dir[dir].push(path)
end

for src_dir, paths in paths_by_dir
  dest_dir = "%s/.trash/%s/%s" % [
      ENV["HOME"], Date.today.to_s(), File.expand_path(src_dir).gsub(/\//, "_")]
  if File.exist?(dest_dir)
    i = 1
    while File.exist?(dest_dir + i.to_s())
      i += 1
    end
    dest_dir += i.to_s()
  end
  FileUtils.mkdir_p(dest_dir)
  FileUtils.mv(paths, dest_dir)
end
