
require 'rubypost'

include RubyPost

#note, can't use underscores in filenames if you are going
#to use File#view.  tex mproof breaks
file = RubyPost::File.new('testpath')

#draw a curved path
fig1 = Figure.new
file.add_figure(fig1)
path = Path.new
path.curved
8.times{ |i| path.add_pair(Pair.new(i.cm, ((i/4.0)**2).cm)) }
fig1.add_drawable(path)

#draw the same path but with an arrow at the end
fig2 = Figure.new
file.add_figure(fig2)
arrow = Path.new.arrow
arrow.curved
8.times{ |i| arrow.add_pair(Pair.new(i.cm, ((i/4.0)**2).cm)) }
fig2.add_drawable(arrow)

#draw the same path but with an arrow on both ends
fig3 = Figure.new
file.add_figure(fig3)
#see the ruby reference for clone symatics
arrow2 = arrow.clone
arrow2.dblarrow
fig3.add_drawable(arrow2)

#draw the same path but with an arrow at the start
#this is achieved by reversing the path
fig4 = Figure.new
file.add_figure(fig4)
#see the ruby reference for clone symatics
arrow3 = arrow.clone
arrow3.reverse
fig4.add_drawable(arrow3)

#draw the arrow but scale it by 0.5 and make it dashed
fig5 = Figure.new
file.add_figure(fig5)
arrow4 = Path.new.arrow
arrow4.add_option(Scale.new(0.5))
arrow4.add_option(Dashed.new)
8.times{ |i| arrow4.add_pair(Pair.new(i.cm, ((i/4.0)**2).cm)) }
fig5.add_drawable(arrow4)

#draw the same arrow but scale it by 0.5 and rotate 140 degrees
#and make it red
fig6 = Figure.new
file.add_figure(fig6)
arrow5 = Path.new.arrow
arrow5.add_option(Rotate.new(140))
arrow5.add_option(Scale.new(0.5))
arrow5.add_option(Colour.new(1.0,0.0,0.0))
8.times{ |i| arrow5.add_pair(Pair.new(i.cm, ((i/4.0)**2).cm)) }
fig6.add_drawable(arrow5)

#draw arrow5 again and draw another arrow but translate right by 5cm.
#note the order of translation and rotation is important.
#also make the colour blue and use a square pen that is
#thickened by a factor of 2
fig7 = Figure.new
file.add_figure(fig7)
arrow6 = Path.new.arrow
arrow6.add_option(Rotate.new(140))
arrow6.add_option(Scale.new(0.5))
arrow6.add_option(Translate.new(Pair.new(5.0.cm,0.0)))
arrow6.add_option(Colour.new(0.0,0.0,1.0))
arrow6.add_option(Pen.new('pensquare', 2.0))
8.times{ |i| arrow6.add_pair(Pair.new(i.cm, ((i/4.0)**2).cm)) }
fig7.add_drawable(arrow6)
fig7.add_drawable(arrow5)

#draw the path, make it cycle
fig8 = Figure.new
file.add_figure(fig8)
cycled_path = Path.new
8.times{ |i| cycled_path.add_pair(Pair.new(i.cm, ((i/3.0)**2).cm)) }
cycled_path.add_pair('cycle')
fig8.add_drawable(cycled_path)

#draw the path, make it cycle and filled with colour
fig9 = Figure.new
file.add_figure(fig9)
filled_path = Path.new.fill
8.times{ |i| filled_path.add_pair(Pair.new(i.cm, ((i/3.0)**2).cm)) }
filled_path.add_pair('cycle')
fig9.add_drawable(filled_path)

#draw the path, make it cycle and filled with colour
fig10 = Figure.new
file.add_figure(fig10)
test_center = Path.new
test_center.add_pair(Pair.new(0.0,0.0))
test_center.add_pair(Pair.new(0.0,3.0.cm))
test_center.add_pair(Pair.new(3.0.cm,3.0.cm))
test_center.add_pair(Pair.new(3.0.cm,0.0))
test_center.add_pair(Pair.new('cycle'))

filled_path.add_pair('cycle')
fig10.add_drawable(filled_path)

puts file.compile_to_string
file.compile
file.view
