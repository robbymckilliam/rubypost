#require 'rubypost'

require '../lib/objects'
require '../lib/drawable'
require '../lib/draw'
require '../lib/options'
require '../lib/graph'

include RubyPost

#note, can't use underscores in filenames if you are going
#to use File#view.  tex mproof breaks
file = RubyPost::File.new('testpath')

#create a curved path
path = Path.new
path.curved
8.times{ |i| path.add_pair(Pair.new(i.cm, ((i/4.0)**2).cm)) }

#draw a curved path
fig1 = Figure.new
file.add_figure(fig1)
fig1.add_drawable(Draw.new(path))

#draw the same path but with an arrow at the end
fig2 = Figure.new
file.add_figure(fig2)
fig2.add_drawable(Arrow.new(path))

#draw the same path but with an arrow on both ends
fig3 = Figure.new
file.add_figure(fig3)
fig3.add_drawable(DoubleArrow.new(path))

#draw the same path but with an arrow at the start
#this is achieved by reversing the path
fig4 = Figure.new
file.add_figure(fig4)
#see the ruby reference for clone symatics
revpath = path.clone
revpath.reverse
fig4.add_drawable(Arrow.new(revpath))

#draw the path but scale it by 0.5 and make it dashed
fig5 = Figure.new
file.add_figure(fig5)
draw_command = Arrow.new.add_option(Scale.new(0.5)).add_option(Dashed.new)
draw_command.set_drawable(path)
fig5.add_drawable(draw_command)

#draw the same arrow but scale it by 0.5 and rotate 140 degrees
#and make it red
fig6 = Figure.new
file.add_figure(fig6)
draw_command = Arrow.new
draw_command.add_option(Rotate.new(140))
draw_command.add_option(Scale.new(0.5))
draw_command.add_option(Colour.new(1.0,0.0,0.0))
draw_command.set_drawable(path)
fig6.add_drawable(draw_command)

#draw the previous arrow again again and draw 
#another arrow but translate right by 5cm. <br>
#Note the order of translation and rotation is important.
#Also make the colour blue and use a square pen that is
#thickened by a factor of 2
fig7 = Figure.new
file.add_figure(fig7)
draw_command2 = Arrow.new
draw_command2.add_option(Rotate.new(140))
draw_command2.add_option(Scale.new(0.5))
draw_command2.add_option(Translate.new(Pair.new(5.0.cm,0.0)))
draw_command2.add_option(Colour.new(0.0,0.0,1.0))
draw_command2.add_option(Pen.new('pensquare', 2.0))
draw_command2.set_drawable(path)
fig7.add_drawable(draw_command)
fig7.add_drawable(draw_command2)

#draw same path, make it cycle and make it use straight lines
fig8 = Figure.new
file.add_figure(fig8)
cycled_path = path.clone
cycled_path.add_pair('cycle')
cycled_path.straight
fig8.add_drawable(Draw.new(cycled_path))

#draw the path, make it cycle and filled with black
fig9 = Figure.new
file.add_figure(fig9)
fig9.add_drawable(Fill.new(cycled_path))

#draw the path, make it cycle and filled with colour
fig10 = Figure.new
file.add_figure(fig10)
fig10.add_drawable(Fill.new(cycled_path).colour(1,0,0))


puts file.compile_to_string
file.compile
file.view
