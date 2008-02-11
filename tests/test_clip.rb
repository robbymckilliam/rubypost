#require 'rubypost'

require '../lib/objects'
require '../lib/drawable'
require '../lib/draw'
require '../lib/options'

include RubyPost

#note, can't use underscores in filenames if you are going
#to use File#view.  tex mproof breaks
file = RubyPost::File.new('testsquare')

#draw a square
fig1 = Figure.new
file.add_figure(fig1)
square1 = RubyPost::Square.new
fig1.add_drawable(Fill.new(square1).scale(10.cm).colour(0.8,0.8,0.8))
fig1.add_drawable(Fill.new(square1).scale(3.cm).colour(0,0,0))

#draw a square same as before but clip the picture back
fig2 = Figure.new
file.add_figure(fig2)
fig2.add_drawable(Fill.new(square1).scale(10.cm).colour(0.8,0.8,0.8))
fig2.add_drawable(Fill.new(square1).scale(3.cm).colour(0,0,0))
fig2.add_drawable(Clip.new(square1).scale(7.cm))


puts file.compile_to_string
file.compile
file.view