#require 'rubygems'
#gem 'rubypost'
#require 'rubypost'

#load the rest of rubypost
require '../lib/objects'
require '../lib/drawable'
require '../lib/options'

include RubyPost

#note, can't use underscores in filenames if you are going
#to use File#view.  tex mproof breaks
file = RubyPost::File.new('testsquare')

#draw a square
fig1 = Figure.new
file.add_figure(fig1)
square1 = RubyPost::Square.new.scale(1.cm)
fig1.add_drawable(square1)

#draw a curved path
fig2 = Figure.new
file.add_figure(fig2)
square2 = RubyPost::Square.new
square2.add_option(Rotate.new(45))
square2.add_option(Scale.new(2.cm))
square2.add_option(Colour.new(1.0,0.0,1.0))
square2.add_option(Dashed.new)
square2.add_option(Pen.new('pencircle', 2.0))
fig2.add_drawable(square2)

#draw a green filled square
#we are using the colour method for Drawable.  It actually just
#calls add_option(Colour.new(r,g,b))
fig3 = Figure.new
file.add_figure(fig3)
square3= RubyPost::Square.new.fill.scale(1.cm).colour(0.0,1.0,0.0)
fig3.add_drawable(square3)


puts file.compile_to_string
file.compile
file.view