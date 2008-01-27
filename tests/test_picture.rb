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

fig.add_drawable(Draw.new(pic).rotate(45).translate(0,-5.cm).colour(0,0,1))

puts file.compile_to_string
file.compile
file.view

