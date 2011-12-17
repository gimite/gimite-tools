#!/usr/bin/env ruby

# License: Public Domain
# Author: Hiroshi Ichikawa (Gimite) <http://gimite.net/en/>

# Replaces strings using regexp.

require "set"

escape_map = {
  "n" => "\n",
  "r" => "\r",
  "t" => "\t",
}

if ARGV.size < 3
  $stderr.puts("Usage: udevas pattern replacement files..")
  exit(1)
end

begin
  pattern = Regexp.new(ARGV[0])
rescue RegexpError
  $stderr.puts("Invalid regexp: '%s'" % ARGV[0])
  exit(1)
end
replace = ARGV[1].gsub(/\\(.)/){ escape_map[$1] || $& }
filters = ARGV[2..-1]

file_names = Set.new()
for filter in filters
  names = Dir[filter]
  if names.empty?
    $stderr.puts("No match: #{filter}")
  else
    names.each(){ |n| file_names.add(n) }
  end
end

for file_name in file_names
  if !File.exist?(file_name)
    $stderr.puts("No such file or directory: #{file_name}")
  elsif !File.directory?(file_name)
    text = nil
    open(file_name){ |f| text = f.read() }
    if !text.valid_encoding?
      $stderr.puts("Skipping (probably) binary file: #{file_name}")
      next
    end
    if text.gsub!(pattern, replace)
      open(file_name, "w"){ |f| f.print(text) }
    end
  end
end
