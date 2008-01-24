#require 'rubypost'

require '../lib/objects'
require '../lib/drawable'
require '../lib/options'
require '../lib/graph'

include RubyPost

file = RubyPost::File.new('testpicture')
fig = Figure.new

pic = Picture.new('testpic')
fig.add_drawable(pic)
file.add_figure(fig)

pic.add_drawable(Square.new.scale(1.cm))
pic.add_drawable(Circle.new.scale(1.cm))
pic.add_option(Rotate.new(45))

pic2 = pic.clone
pic2.add_option(Scale.new(2))
#fig.add_drawable(pic2)

puts file.compile_to_string
file.compile
file.view

