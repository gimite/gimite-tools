#!/usr/bin/env ruby

# License: Public Domain
# Author: Hiroshi Ichikawa (Gimite) <http://gimite.net/en/>

# Makes XML easier to read.

$KCODE = "u"
require "rexml/document"


doc = REXML::Document.new(ARGF.read())
doc.write($stdout, 2)
