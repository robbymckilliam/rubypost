#require 'rubypost'

require '../lib/objects'
require '../lib/drawable'
require '../lib/draw'
require '../lib/options'
require '../lib/graph'

include RubyPost

#note, can't use underscores in filenames if you are going
#to use File#view.  tex mproof breaks
file = RubyPost::File.new('testsquare')

#draw a square
fig1 = Figure.new
file.add_figure(fig1)
square1 = RubyPost::Square.new
fig1.add_drawable(Draw.new(square1).scale(1.cm))

#draw a square with a circular and thickened pen.  Also
#rotate and change scale and colour
fig2 = Figure.new
file.add_figure(fig2)
square_drawer = Draw.new
square_drawer.add_option(Rotate.new(45))
square_drawer.add_option(Scale.new(2.cm))
square_drawer.add_option(Colour.new(1.0,0.0,1.0))
square_drawer.add_option(Dashed.new)
square_drawer.add_option(Pen.new('pencircle', 2.0))
fig2.add_drawable(square_drawer.set_drawable(square1))

#draw a green filled square
#we are using the colour method for Drawable.  It actually just
#calls add_option(Colour.new(r,g,b))
fig3 = Figure.new
file.add_figure(fig3)
square_drawer = Fill.new.scale(1.cm).colour(0.0,1.0,0.0).set_drawable(square1)
fig3.add_drawable(square_drawer)


puts file.compile_to_string
file.compile
file.view