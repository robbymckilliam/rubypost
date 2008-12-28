#code to generate a plot of the data in metapost format
#require 'rubypost'

require '../lib/objects'
require '../lib/drawable'
require '../lib/draw'
require '../lib/options'
require '../lib/label'
require '../lib/graph'

include RubyPost

file = RubyPost::File.new
fig = Figure.new
file.add_figure(fig)

graph = Graph.new
graph.add_graph_option(XLabel.new(latex('x label')))
graph.add_graph_option(GraphTitle.new(latex('A graph title')))
graph.add_graph_option(YLabel.new(latex('the y label')))
graph.add_graph_option(YLabelRight.new(latex('the y label on the right')))
fig.add_drawable(Draw.new(graph))

#plot y = x^2
x = (1..20).to_a
y = Array.new
x.each { |v| y.push(v**2) }
gd = GraphData.new(x, y)
gd.add_option(RubyPost::Colour.new(0.0,1.0,0.0))
graph.add_data(gd)

gd.add_label(GraphLabel.new(latex("data label"), 5).right)

puts file.compile_to_string
file.compile('testgraph')

file.dvi_viewer = 'evince'
file.view