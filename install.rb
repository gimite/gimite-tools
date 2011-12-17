#!/usr/bin/env ruby

# License: Public Domain
# Author: Hiroshi Ichikawa (Gimite) <http://gimite.net/en/>

# Installs commands in this directory.

require "fileutils"


fu = FileUtils::Verbose
dest_dir = ARGV.empty? ? ENV["HOME"] + "/bin" : ARGV[0]
fu.mkdir_p(dest_dir)
for file_name in Dir["*.rb"]
  next if file_name == "install.rb"
  dest_path = "%s/%s" % [dest_dir, File.basename(file_name, ".*")]
  next if File.exist?(dest_path)
  fu.ln_s(File.expand_path(file_name), dest_path)
end
