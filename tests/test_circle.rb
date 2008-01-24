#code to generate a plot of the data in metapost format
require 'rubypost'

include RubyPost

#note, can't use underscores in filenames if you are going
#to use File#view.  tex mproof breaks
file = RubyPost::File.new('testcircle')

#draw a circle
fig1 = Figure.new
file.add_figure(fig1)
circle1 = RubyPost::Circle.new.scale(1.cm)
fig1.add_drawable(circle1)

puts file.compile_to_string
file.compile
file.view