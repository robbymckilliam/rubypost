#code to generate a plot of the data in metapost format
#require 'rubypost'

require '../lib/objects'
require '../lib/drawable'
require '../lib/draw'
require '../lib/options'

include RubyPost

#note, can't use underscores in filenames if you are going
#to use File#view.  tex mproof breaks
file = RubyPost::File.new('testcircle')

#draw a circle
fig1 = Figure.new
file.add_figure(fig1)
circle1 = RubyPost::Circle.new
fig1.add_drawable(Draw.new(circle1).scale(1.cm))

puts file.compile_to_string
file.compile
file.view