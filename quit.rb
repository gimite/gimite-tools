#!/usr/bin/env ruby

# License: Public Domain
# Author: Hiroshi Ichikawa (Gimite) <http://gimite.net/en/>

# Kills a process specified by part of command or PID.

require "optparse"
require "enumerator"


def process_exist?(pid)
  begin
    Process.getpgid(pid)
    return true
  rescue
    return false
  end
end

def ps_to_pid(line)
  line.split(/\s+/)[1].to_i()
end


Thread.abort_on_exception= true
$stderr.sync= true

@opts = OptionParser.getopts("i")
interactive= @opts["i"]
if ARGV[0] =~ /^\d+$/
  pid = ARGV[0].to_i()
else
  keyword = ARGV[0]
  lines = `ps auxww`.enum_for(:each_line).
    select(){ |s| s.index(keyword) && ps_to_pid(s) != Process.pid }
  lines.each_with_index() do |line, i|
    puts("#{i}: #{line}")
  end
  print("Number: ")
  pid = ps_to_pid(lines[$stdin.gets().chomp().to_i()])
end

if !process_exist?(pid)
  $stderr.puts("No such process")
  exit(1)
end

Thread.new() do
  while process_exist?(pid)
    sleep(0.1)
  end
  exit()
end

begin
  for signal in [:INT, :TERM, :ABRT, :KILL]
    if signal != :INT
      sleep(5)
      if interactive
        $stderr.print(
          "Process still running. Send signal #{signal}? (Y/n) ")
        exit(1) if !($stdin.gets() =~ /^(y|yes)?$/i)
      end
    end
    $stderr.puts("Sending signal #{signal}...")
    Process.kill(signal, pid)
  end
  sleep()
rescue SystemCallError => ex
  $stderr.puts(ex.message)
end
