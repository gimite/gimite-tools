#!/usr/bin/env ruby

# License: Public Domain
# Author: Hiroshi Ichikawa (Gimite) <http://gimite.net/en/>

# Makes JSON easier to read.

require "rubygems"
require "json"


puts(JSON.pretty_generate(JSON.load(ARGF)))
