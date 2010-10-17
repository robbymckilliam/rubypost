#require 'rubypost'

require '../lib/objects'
require '../lib/drawable'
require '../lib/draw'
require '../lib/options'
require '../lib/simpleplot'
#require '../lib/graph'

include RubyPost

#note, can't use underscores in filenames if you are going
#to use File#view.  tex mproof breaks
file = RubyPost::File.new('testsimpleplot')

x = (-3..3).to_a
y = x.map { |v| v**2 }

lplot = CurvedPlot.new(x,y).add_option(Colour.new(1.0,0,0))
splot = LinePlot.new(x,y).add_option(Colour.new(1.0,0,0))
iplot = ImpulsePlot.new(x,y).add_option(Colour.new(0,1.0,0))
stemplot = StemPlot.new(x,y).add_option(Colour.new(0,0,1.0))

#draw a curved path
fig1 = Figure.new
file.add_figure(fig1)
fig1.add_drawable(lplot)


simpplot = SimplePlot.new(10, 5)
simpplot.add_plot(lplot)
simpplot.add_plot(splot)
simpplot.add_plot(iplot)
simpplot.add_plot(stemplot)
simpplot.xticks(x)
simpplot.yticks([3,6,9])
simpplot.xlabel(latex('t'))
simpplot.ylabel(latex('X(t)'))


#draw a curved path
fig2 = Figure.new
file.add_figure(fig2)
fig2.add_drawable(Draw.new(simpplot))


puts file.compile_to_string
file.compile
#file.view
