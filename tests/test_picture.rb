#require 'rubypost'

require '../lib/objects'
require '../lib/drawable'
require '../lib/draw'
require '../lib/options'
require '../lib/graph'

include RubyPost

file = RubyPost::File.new('testpicture')
fig = Figure.new

pic = Picture.new('testpic')
fig.add_drawable(Draw.new(pic))
file.add_figure(fig)

pic.add_drawable(Draw.new(Square.new).scale(1.cm))
pic.add_drawable(Draw.new(Circle.new).scale(1.cm))

#note that you have to be aware of the order in which
#you apply scale, rotation and translation!
fig.add_drawable(Draw.new(pic).scale(2).rotate(45).translate(0,-5.cm).colour(0,0,1))

puts file.compile_to_string
file.compile
file.view

